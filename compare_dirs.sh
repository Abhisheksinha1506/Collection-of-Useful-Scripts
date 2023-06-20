#!/bin/bash
# This script is meant to compare two directories, check MD5 hashes of all the
# files in both directories, to see which ones are identical and which aren't.
# The script also checks the number of files and will list potential missing
# files that exist in either directory, but not in the other.

# The script takes two arguments, both being directories.

set -eo pipefail

# Checks if the user has 'md5sum' installed. This will probably not be the case
# for macOS or FreeBSD, and that's why we're checking. If such a user wants to
# run this script, he / she can just change the script to use 'md5' instead, and
# parse the output accordingly.
is_md5sum=$(command -v md5sum)

if [[ -z $is_md5sum ]]; then
	echo -e "\nThis script needs 'md5sum' installed to run!\n"
	exit
fi

usage () {
	echo -e "\nUsage: $(basename "$0") [dir1] [dir2]\n"
	exit
}

# Checks if arguments are directories, and quits if they aren't.
if [[ -z $1 || -z $2 ]]; then
	usage
elif [[ ! -d $1 || ! -d $2  ]]; then
	usage
fi

# Gets absolute path of both directories.
dir1=$(readlink -f "$1")
dir2=$(readlink -f "$2")

# Gets the total size of both directories.
dir1_size=$(du -b -s "$dir1" | sed -E 's/[[:blank:]]+/ /g' | cut -d' ' -f1)
dir2_size=$(du -b -s "$dir2" | sed -E 's/[[:blank:]]+/ /g' | cut -d' ' -f1)

# Lists all the files and directories in both directories.
mapfile -t dir1_files < <(find "$dir1" -type f -iname "*" 2>&- | sort | sed -E 's/\$/\\$/g')
mapfile -t dir1_dirs < <(find "$dir1" -mindepth 1 -type d -empty 2>&- | sort | sed -E 's/\$/\\$/g')
mapfile -t dir2_files < <(find "$dir2" -type f -iname "*" 2>&- | sort | sed -E 's/\$/\\$/g')
mapfile -t dir2_dirs < <(find "$dir2" -mindepth 1 -type d -empty 2>&- | sort | sed -E 's/\$/\\$/g')

dir1_files_elements="${#dir1_files[@]}"
dir1_dirs_elements="${#dir1_dirs[@]}"
dir2_files_elements="${#dir2_files[@]}"
dir2_dirs_elements="${#dir2_dirs[@]}"

# Declares some hashes that will be used to compare the two directories.
var_list1=(dir1_files_hash dir1_dirs_hash dir2_files_hash dir2_dirs_hash dir1_md5s_hash dir2_md5s_hash)
declare -A "${var_list1[@]}"

# Converts the basename of all the files (in both directories) into MD5 hashes,
# to be more easily processed later in the script.
for dir in dir1 dir2; do
	for type in files dirs; do
		elements_ref="${dir}_${type}_elements"

		for (( i = 0; i < ${!elements_ref}; i++ )); do
			tmp_ref="${dir}_${type}[${i}]"
			dir_ref="${dir}"

# Removes the directory name from the beginning of the string. Creating the
# basename this way because it's more safe than using regex:es, if the string
# contains weird characters (that are interpreted as part of the regex).
			mapfile -d'/' -t path_parts <<<"${!dir_ref}"
			start=$(( ${#path_parts[@]} + 1 ))
			bn=$(cut -d'/' -f${start}- <<<"${!tmp_ref}")

# Okay, we're done messing with the string now. Now to create the MD5 hash.
			bn_md5=$(md5sum -b <<<"${bn}" | cut -d' ' -f1)
			eval ${dir}_${type}_hash[${bn_md5}]=\""${bn}"\"
		done

		unset -v "${dir}_type"
	done
done

unset -v path_parts bn_md5

# Generates an MD5 hash of all the basenames that exist in both directories.
# This is faster than checking the MD5 hash of *all* the files. We only need to
# check the file names that exist in both directories.
for key in "${!dir1_files_hash[@]}"; do
	dir1_f="${dir1}/${dir1_files_hash[${key}]}"

	if [[ ${dir2_files_hash[${key}]} ]]; then
		dir2_f="${dir2}/${dir2_files_hash[${key}]}"

		dir1_md5s_hash[${key}]=$(md5sum -b "${dir1_f}" | cut -d' ' -f1)
		dir2_md5s_hash[${key}]=$(md5sum -b "${dir2_f}" | cut -d' ' -f1)
	fi
done

# Compares the two directories to see if files or directories are missing.
var_list2=(dir1_files_missing dir1_dirs_missing dir2_files_missing dir2_dirs_missing md5s_mismatch)
declare -a "${var_list2[@]}"

# Files
for key in "${!dir1_files_hash[@]}"; do
	if [[ -z ${dir2_files_hash[${key}]} ]]; then
		dir2_files_missing+=("${dir1_files_hash[${key}]}")
	elif [[ ${dir1_md5s_hash[${key}]} != ${dir2_md5s_hash[${key}]} ]]; then
		md5s_mismatch+=("${dir1_files_hash[${key}]}")
	fi
done

for key in "${!dir2_files_hash[@]}"; do
	if [[ -z ${dir1_files_hash[${key}]} ]]; then
		dir1_files_missing+=("${dir2_files_hash[${key}]}")
	fi
done

# Directories
for key in "${!dir1_dirs_hash[@]}"; do
	if [[ -z ${dir2_dirs_hash[${key}]} ]]; then
		dir2_dirs_missing+=("${dir1_dirs_hash[${key}]}")
	fi
done

for key in "${!dir2_dirs_hash[@]}"; do
	if [[ -z ${dir1_dirs_hash[${key}]} ]]; then
		dir1_dirs_missing+=("${dir2_dirs_hash[${key}]}")
	fi
done

unset -v "${var_list1[@]}"

dir1_files_missing_elements="${#dir1_files_missing[@]}"
dir1_dirs_missing_elements="${#dir1_dirs_missing[@]}"
dir2_files_missing_elements="${#dir2_files_missing[@]}"
dir2_dirs_missing_elements="${#dir2_dirs_missing[@]}"
md5s_mismatch_elements="${#md5s_mismatch[@]}"

identical='1'

# Prints the result.
print_list () {
	tmp_f="/dev/shm/${type}-${RANDOM}.txt"
	touch "$tmp_f"

	for (( i = 0; i < ${!elements_ref}; i++ )); do
		tmp_ref="${type}[${i}]"
		echo "${!tmp_ref}" >> "$tmp_f"
	done

	unset -v "$type"

	sort <"$tmp_f"
	rm -f "$tmp_f"

	echo
}

for type in "${var_list2[@]}"; do
	elements_ref="${type}_elements"

	if [[ ${!elements_ref} -gt 0 ]]; then
		identical='0'
	else
		continue
	fi

	echo

	case $type in
		'dir1_files_missing')
			echo "*** 1:${dir1}"
			echo -e "The files below are missing:\n"

			print_list
		;;
		'dir1_dirs_missing')
			echo "*** 1:${dir1}"
			echo -e "The directories below are missing:\n"

			print_list
		;;
		'dir2_files_missing')
			echo "*** 2:${dir2}"
			echo -e "The files below are missing:\n"

			print_list
		;;
		'dir2_dirs_missing')
			echo "*** 2:${dir2}"
			echo -e "The directories below are missing:\n"

			print_list
		;;
		'md5s_mismatch')
			echo "*** 1:${dir1}"
			echo "*** 2:${dir2}"
			echo -e "MD5 hash mismatch:\n"

			print_list
		;;
	esac
done

# If directories are identical, the code above will have printed nothing, so
# we print a message saying that the directories are identical.
if [[ $identical -eq 1 ]]; then
	cat <<P_IDENT

*** 1:${dir1}
*** 2:${dir2}
The directories are identical!

P_IDENT
fi

# Prints size.
cat <<P_SUM

*** 1:${dir1}
*** 2:${dir2}
Summary:

1:${dir1_size} bytes
2:${dir2_size} bytes

1:${dir1_files_elements} files
2:${dir2_files_elements} files

P_SUM
