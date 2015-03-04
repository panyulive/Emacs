(require 'cl)
(setq exec-path (cons "/usr/local/bin"exec-path))

(tool-bar-mode 0)
(scroll-bar-mode 0)

(when (<  emacs-major-version 23)
        (defvar user-emacs-directory "~/.emacs.d/"))

;;load-pathを追加する関数定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;;引数のディレクトリとサブディレクトリをload-pathに追加 snippet
(add-to-load-path "lisp" 
				  "conf" 
				  "elpa" 
				  "howm-1.4.1" 
				  "auto-install" 
				  "snippets"
)

(require 'init-loader)
(init-loader-load "~/.emacs.d/conf")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(shell-pop-shell-type (quote ("eshell" "*eshell*" (lambda nil (eshell)))))
 '(yas-trigger-key "TAB"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(howm-mode-title-face ((t (:foreground "Yellow")))))
