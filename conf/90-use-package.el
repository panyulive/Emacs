(eval-when-compile
  (require 'use-package))
  (require 'bind-key)

(use-package web-mode
  :mode ((web-mode))
  :init
  :config
  )

(use-package shell-pop
  :commands (shell-pop)
  :bind (("C-p" . shell-pop))
  :config
  (use-package exec-path-from-shell
	:config
	(exec-path-from-shell-initialize)
	)
  
  (add-hook 'eshell-mode-hook
			'(lambda()
			   (progn
				 (define-key eshell-mode-map (kbd "C-f") 'find-file-other-window)
				 ;;(define-key eshell-mode-map (kbd "<left>"))
				 )))
  
  )


(use-package auto-complete
  :config
  (require 'auto-complete-config)
  (require 'yasnippet)
  )


(use-package magit
  :commands (magit-status)
  :config
  ;;magit Congig
  )

(use-package howm
  :commands (howm-menu)
  :bind (("C-c ,," . howm-menu))

  :init
  ;;howm Config
  (setq howm-menu-lang 'ja)
  ;; howm directoryの場所
  (setq howm-directory "~/Dropbox/emacs/howm/")

  :config
  
  (mapc
   (lambda (f)
	 (autoload f
	   "howm" "Hitori Otegaru Wiki Modoki" t))
   '(howm-menu howm-list-all howm-list-recent
			   howm-list-grep howm-create
			   howm-keyword-to-kill-ring))
  
  (defun howm-save-buffer-and-kill ()
	"howmメモを保存と同時に閉じます。"
	(interactive)
	(when (and (buffer-file-name)
			   (string-match "\\.txt" (buffer-file-name)))
	  (save-buffer)
	  (kill-buffer nil)))
  
  ;; C-c C-cでメモの保存と同時にバッファを閉じる
  ;;(define-key howm-mode-map (kbd "C-c ") 'howm-save-buffer-and-kill)
  
  )


