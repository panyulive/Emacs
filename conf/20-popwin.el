(require 'popwin)
(require 'dired-x)
(setq display-buffer-function 'popwin:display-buffer)

;;diaplay-buffer-functionを変更したくない人向け
;;(setq special-display-function 'popwin:special-display-popup-window)

(setq popwin:special-display-config '(("*scratch*")))
(display-buffer "*scratch*")

(push '(dired-mode :position left) popwin:special-display-config)
