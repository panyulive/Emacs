;;バッファ全体をインデント
(defun indent-whole-buffer ()
  (inrerctive)
  (indent-region (point-min) (point-max)))

(defun all-sjis ()
	(interactive)
	(set-default-coding-systems `sjis)
	(set-keyboard-coding-system `sjis)
	(setq default-buffer-file-coding-system `sjis))

(defun all-def ()
  (interactive)
	(set-default-coding-systems `utf-8)
	(set-keyboard-coding-system `utf-8)
	(setq default-buffer-file-coding-system `utf-8))

(defun duplicate-line (&optional numlines)
  "One line is duplicated wherever there is a cursor."
  (interactive "p")
  (let* ((col (current-column))
         (bol (progn (beginning-of-line) (point)))
         (eol (progn (end-of-line) (point)))
         (line (buffer-substring bol eol)))
    (while (> numlines 0)
      (insert "\n" line)
      (setq numlines (- numlines 1)))
    (move-to-column col)))

(defun indent-whole-buffer()
  (inrerctive)
  (indent-region (point-min) (point-max)))
