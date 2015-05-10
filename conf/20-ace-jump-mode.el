(require 'use-package)
(require 'bind-key)									   
;(require 'use-package)
;(global-set-key (kbd "C-/") 'ace-jump-mode)


(use-package ace-jump-mode
  :defer t
  :bind (( "C-/" . ace-jump-mode ))
  :init
  (autoload 'ace-jump-mode "ace-jump-mode" nil t)
  :config
 
  )



  
