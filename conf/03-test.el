(require 'use-package)
(require 'bind-key)

(use-package gtags
  :config
  
  )



(eval-after-load 'eshell
    '(require 'eshell-z nil t))

(use-package smartparens
  :config
  (smartparens-global-mode t)
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)

  )


(use-package ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby"
  :init
  (require 'ruby-electric)
  (add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
  (setq ruby-electric-expand-delimiters-list nil)
  
  (require 'ruby-block)
  (ruby-block-mode t)
  (setq ruby-block-highlight-toggle t)

  (require 'rcodetools)
  (setq rct-find-tag-if-available nil)
  
;  (require 'inf-ruby)

  (require 'highlight-thing)
;;; 現在の関数のみをハイライト対象にする
  (setq highlight-thing-limit-to-defun t)
  
  
  :config
  ;;recodetools
  (bind-keys :map ruby-mode-map
             ("M-C-i"   . rct-complete-symbol)
             ("C-c C-t" . ruby-toggle-buffer)
             ("C-c C-f" . rct-ri)
             ("M-p" .     xmp))

  (add-to-list 'ruby-mode-hook 'highlight-thing-mode)
  )
