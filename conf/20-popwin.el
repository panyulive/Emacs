(require 'popwin)
(require 'dired)
(require 'dired-x)
(require 'dired-toggle)
(require 'dired-details)
(require 'direx)

(setq display-buffer-function 'popwin:display-buffer)

;;diaplay-buffer-functionを変更したくない人向け
;;(setq special-display-function 'popwin:special-display-popup-window)

(setq popwin:special-display-config '(("*scratch*")
                                      ("*Dired\  Toggle*")))
;(display-buffer "*scratch*")

(push '(dired-mode :position left :width 40) popwin:special-display-config)

(setq direx:lead-icon   "  "
      direx:open-icon   "- "
      direx:closed-icon "+ ")
(push '(direx:direx-mode :position left :width 40 :dedicated t)
      popwin:special-display-config)

(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
(global-set-key (kbd "C-x C-d") 'dired-toggle)
(dired-details-install)

(setq dired-details-hidden-string "")
(setq dired-details-hide-link-targets nil)

(defadvice find-dired-sentinel (after dired-details (proc state) activate)
  "find-diredでもdired-detailsを使えるようにする"
  (ignore-errors
    (with-current-buffer (process-buffer proc)
      (dired-details-activate))))

