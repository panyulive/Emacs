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
  
  

