(require 'helm)

(global-set-key (kbd "C-x C-h") 'helm-mini)
(global-set-key (kbd "C-c C-r") 'helm-recentf)
;;(global-set-key (kbd "C-") 'helm-)
(helm-mode t)
