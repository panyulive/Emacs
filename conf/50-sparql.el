(autoload 'sparqling-mode "sparqling-mode" "Mode for editing SPARQL files" t)
(setq auto-mode-alist
      (cons (cons "\\.rq$" 'sparqling-mode) auto-mode-alist))
