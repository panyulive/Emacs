(defun revert-buffer-no-confirm (&optional force-reverting)
  "Interactive call to revert-buffer. Ignoring the auto-save
 file and not requesting for confirmation. When the current buffer
 is modified, the command refuses to revert it, unless you specify
 the optional argument: force-reverting to true."
  (interactive "P")
  ;;(message "force-reverting value is %s" force-reverting)
  (if (or force-reverting (not (buffer-modified-p)))
      (revert-buffer :ignore-auto :noconfirm)
    (error "The buffer has been modified")))


(setq ring-bell-function 'ignore)

;(global-set-key (kbd "C-y") 'duplicate-line)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-x C-i") 'helm-imenu)

(global-set-key (kbd "M-r") 'revert-buffer-no-confirm)
