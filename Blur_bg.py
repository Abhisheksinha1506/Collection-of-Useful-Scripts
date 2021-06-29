import cv2
import time
import numpy as np


# Get the webcam
cap = cv2.VideoCapture(0)

# Time is just used to get the Frames Per Second (FPS)
last_time = time.time()
while True:
    # Step 1: Capture the frame
    _, frame = cap.read()

    # Step 2: Convert to the HSV color space
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    # Step 3: Create a mask based on medium to high Saturation and Value
    # - These values can be changed (the lower ones) to fit your environment
    mask = cv2.inRange(hsv, (0, 75, 40), (180, 255, 255))
    # We need a to copy the mask 3 times to fit the frames
    mask_3d = np.repeat(mask[:, :, np.newaxis], 3, axis=2)
    # Step 4: Create a blurred frame using Gaussian blur
    blurred_frame = cv2.GaussianBlur(frame, (25, 25), 0)
    # Step 5: Combine the original with the blurred frame based on mask
    frame = np.where(mask_3d == (255, 255, 255), frame, blurred_frame)

    # Add a FPS label to image
    text = f"FPS: {int(1 / (time.time() - last_time))}"
    last_time = time.time()
    cv2.putText(frame, text, (10, 20), cv2.FONT_HERSHEY_PLAIN, 2, (0, 255, 0), 2)

    # Step 6: Show the frame with blurred background
    cv2.imshow("Webcam", frame)
    # If q is pressed terminate
    if cv2.waitKey(1) == ord('q'):
        break

# Release and destroy all windows
cap.release()
cv2.destroyAllWindows()
