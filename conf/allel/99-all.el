;; 終了時バイトコンパイル
(add-hook 'kill-emacs-query-functions
          (lambda ()
            (if (file-newer-than-file-p (concat user-emacs-directory "init.el") (concat user-emacs-directory "init.elc"))
                (byte-compile-file (concat user-emacs-directory "init.el")))
            ;(if (file-newer-than-file-p (concat user-emacs-directory "filecachedir.el") (concat user-emacs-directory "filecachedir.elc"))
            ;    (byte-compile-file (concat user-emacs-directory "filecachedir.el")))
            (byte-recompile-directory (concat user-emacs-directory "conf") 0)
            )
)
(text-scale-set 1)
;;行番号表示
(global-linum-mode t)
(setq linum-format " %d ")

