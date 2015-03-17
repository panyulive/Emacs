(require 'popwin)
(popwin-mode 1)
(setq display-buffer-function 'popwin:display-buffer)

;;(require 'shackle)
;;(setq shackle-rules
;;	  '(direx:direx-mode :align left :ratio 0.6))
;;(shackle-mode 1)
;;(set shackle-lighter "")

;;(winner-mode 1)
;;(global-set-key (kbd "C-b") 'winner-undo)
		 

;; direx
(require 'direx)
(setq direx:leaf-icon " "
	  direx:open-icon "▼ "
	  direx:closed-icon "▶ ")
(push '(direx:direx-mode :position left :width 30 :dedicated t)
	  popwin:special-display-config)

(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
	  

