;; <2020-07-16 Thu 15:03> rpc - Setup the breathing exercises recorder.

(defvar stopwatchBufferName "*stopwatch1*"
  "Buffer name for buffer stopwatch is running in.")

(defvar csvFile "/home/rick/share/notes/breath1.csv"
  "CSV file that is being fed the data.")

(defvar segments '("Initial" "EmptyHold" "InBreath" "FullHold"))
;;(nth 0 segments) ;; use nth!

(defvar segmentidx 0)

(defvar segment-datetime "00-00-00-00-00" "Hold datetime for start of current routine.")

(defvar laptimes '())

(defconst PBlaps 4  "Number of laps in full PB (Power Breath) session.")

(defvar usingWHM 4 "setup for the 4 segment series suggested bt Wim Hof.")
(defvar lapNum 0 "If usingWHM, used to end session at 4th lap.")

(defun prana-addrow()
  "<2020-07-18 Sat 18:02> rpc - add a row to the csv file holding the timing data."
  (getLapTimes)
  (let ((rlaps (reverse laptimes)))
    (add-to-list 'rlaps segment-datetime)
    (csvs-insertrow rlaps)))



(defun prana-start ()
  "<2020-07-16 Thu 15:04> rpc - Starts the stopwatch in `stopwatchBufferName'
from the current buffer, Cursor remains in current buffer.
`pymacs-load' is called to load python code (/home/rick/share/python/pymacs/csvs.py)
which puts the data into `csvFile'. See ~/share/notes/notes-breathing for example output."
  (interactive)
  (setq laptimes '())
  (setq lapNum 0)
  (setq segment-datetime (format-time-string "%m-%d-%y-%H-%M"))
  (setq segmentidx 0)
  (pymacs-load "csvs")
  (csvs-setCsvFilePath csvFile)
  (if (get-buffer stopwatchBufferName)
      (progn (delete-other-windows)
             (switch-to-buffer-other-window "*stopwatch1*"))
    (progn
      (stopwatch)
      (rename-buffer "*stopwatch1*")))
  (other-window 1)
  (local-set-key "\M-z" 'show-stopwatch-below)
  (insert-headstar)
  (org-todo2 (nth segmentidx segments))
  (setq segmentidx (+ 1 segmentidx))
  (org-end-of-line))

(defun start-new-lap ()
  "<2020-07-19 Sun 09:17> rpc - called when new lap is started."
  (setq lapNum (+ lapNum 1))
  (if (eq usingWHM lapNum) (full-stop)
    (progn (other-window 1)
           (insert (concat " -<" (nth 1 (getLapTimes)) ">- "))
           (org-insert-subheading 1)
           (org-todo2 (nth segmentidx segments))
           (setq segmentidx (+ 1 segmentidx))
           (org-end-of-line))))

(defun show-stopwatch-below ()
  "<2020-07-19 Sun 11:28> rpc - Show the stopwatch window below and switch to it."
  (interactive)
  (switch-to-buffer-other-window "*stopwatch1*"))

(defun full-stop ()
  "'f' in the stopwatch window stops the stopwatch, and puts the proper laptime up here.
Also sends the line to the csv file."
  (interactive)
  (stopwatch-controller--stop-stopwatch StopwatchController)
  (other-window 1)
  (insert (concat "-<" (nth 1 (getLapTimes)) ">- "))
  (org-insert-subheading 1)
  (let ((testit (y-or-n-p "Add session to csv file?")))
    (if testit (prana-addrow))))
  
(defun jump-to-write ()
  (interactive)
  (other-window 1)
  (insert (concat "-<" (car (getLapTimes)) ">- "))
  (org-end-of-line))

(defun getLapTimes()
  (interactive)
  (let* ((swmod (stopwatch-controller--get-model StopwatchController))
         (mlaps (stopwatch-get-all-laps (stopwatch-stop swmod))))
    (setq laptimes (seq-map 'stopwatch-to-watchface-string-precise mlaps))))

(defun insert-laptimes()
  (interactive)
  (getLapTimes)
  (dolist (elt (reverse laptimes))
    (insert (format " %s, " elt))))

  


