(require 'helm)

(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-c C-r") 'helm-recentf)
;;(global-set-key (kbd "C-") 'helm-)
(helm-mode t)
