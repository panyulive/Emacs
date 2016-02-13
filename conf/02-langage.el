(require 'use-package)
(require 'bind-key)

(add-to-list 'auto-mode-alist
        '("\\.zshrc" . shell-script-mode))

(add-to-list 'exec-path (expand-file-name "/usr/local/bin"))
(add-to-list 'exec-path (expand-file-name "/Users/k12144kk/.go/bin"))

(use-package go-autocomplete)
(use-package auto-complete-config)
(use-package go-flycheck)
;; js2-mode
;; https://github.com/mooz/js2-mode/tree/
(use-package js2-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
  (custom-set-variables
   '(js2-auto-indent-p t)
   '(js2-indent-tabs-mode nil) ; indent is space
   '(js2-basic-offset 2)
   '(js2-enter-indents-newline t)
   '(js2-indent-on-enter-key t)
   '(js2-mirror-mode t))
  )

(setq js2-mode-hook
      '(lambda() (progn
                   (set-variable 'indent-tabs-mode nil))))

;;Install
;;PC$ brew install ctags
;;PC$ git clone https://github.com/jixiuf/helm-etags-plus
;;PC$ git clone https://github.com/victorhge/iedit

;;PC$ mkdir /path/to/your/clone-package/jedi
;;PC$ cd    /path/to/your/clone-package/jedi
;;PC$ git clone git://github.com/tkf/emacs-jedi
;;PC$ git clone git://github.com/kiwanami/emacs-deferred
;;PC$ git clone git://github.com/kiwanami/emacs-epc
;;PC$ git clone git://github.com/kiwanami/emacs-ctable

;;jedi config

;;PC$ ~/.emacs.d/path/to/your/jedi/emacs-jedi
;;PC$ virtualenv env
;;PC$ source env/bin/activate
;;PC$ pip install jedi epc

;;READ THIS
;;helm-etags+ need this command
;;PC$ ctags -o TAGS *.py


;;Dont use
;;リファクタリングツール  -->  Ropemacs
;;http://rope.sourceforge.net/ropemacs.html


(use-package python-mode
  :init
  (require 'helm-etags+)
  (require 'anzu)
  (require 'iedit)
  (require 'auto-complete-config)
  (require 'python)
  (require 'jedi)
  
  (add-hook 'python-mode-hook
            '(lambda ()
               (setq indent-tabs-mode nil)
               (setq indent-level 2)
               (setq python-indent 2)
               (setq tab-width 2)
               ))
  
  :config
  (semantic-mode t)
  (add-hook 'python-mode-hook
            (lambda ()
              (setq imenu-create-indent-function 'python-imenu-create-index)))

  (anzu-mode t)
  (when (load "flymake" t)
     (defun flymake-pyflakes-init ()
     ; Make sure it's not a remote buffer or flymake would not work
     (when (not (subsetp (list (current-buffer)) (tramp-list-remote-buffers)))
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "pyflakes" (list local-file)))))
     
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))

  
  )

(autoload 'sparqling-mode "sparqling-mode" "Mode for editing SPARQL files" t)
(setq auto-mode-alist
      (cons (cons "\\.rq$" 'sparqling-mode) auto-mode-alist))
(use-package web-mode

  :mode (
		 "\\.phtml\\'"    
		 "\\.tpl\\.php\\'"
		 "\\.[agj]sp\\'"  
		 "\\.as[cp]x\\'"  
		 "\\.erb\\'"      
		 "\\.mustache\\'" 
		 "\\.djhtml\\'"   
		 )

  :config
  (defun web-mode-hook ()
	  (setq web-mode-markup-indent-offset   2)
	  (setq indent-tabs-mode t)
	  )

  (add-hook 'web-mode-hook 'web-mode-hook)
  )


(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.txt\\'". gfm-mode))
  :init
  (require 'livedown)
  (custom-set-variables
   '(livedown:autostart nil) ; automatically open preview when opening markdown files 
   '(livedown:open t)        ; automatically open the browser window
   '(livedown:port 1337))    ; port for livedown server

  :config
  (bind-keys :map gfm-mode-map
             ("ESC C-p" . livedown:preview))
  )
