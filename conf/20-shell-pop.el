(require 'shell-pop)
(require 'exec-path-from-shell)


(exec-path-from-shell-initialize)

(global-set-key (kbd "C-p") 'shell-pop)
