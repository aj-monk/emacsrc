;; emacs startup script
;; Copy this file as ${HOME}/.emacs, or better still include
;; it in ${HOME}/.emacs like so:
;; (load "<PATH TO REPO>/emacsrc/emacsrc.el")

;; Get rid of the startup screen
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("." . "~/.emacs.d/emacs-backup")))
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; Save mini buffer history
(savehist-mode 1)
(setq savehist-file "~/emacs/history")

;; Save open windows
(desktop-save-mode 1)
(setq history-length 250) ;; Set length of history
(add-to-list 'desktop-globals-to-save 'file-name-history) ;; Stores history in desktop session
(setq desktop-path '("~/.emacs.d/emacs-backup"))
(setq desktop-base-file-name "emacs-desktop")

;; list saved sessions
(defun saved-session ()
  "List saved desktop session"
  (interactive)
  (file-exists-p (concat desktop-dirname "/" desktop-base-file-name)))

;; use session-restore to restore the desktop manually
(defun session-restore ()
  "Restore a saved emacs session."
  (interactive)
  (if (saved-session)
      (desktop-read)
    (message "No desktop found.")))

;; use session-save to save the desktop manually
(defun session-save ()
  "Save an emacs session."
  (interactive)
  (if (saved-session)
      (if (y-or-n-p "Overwrite existing desktop? ")
          (desktop-save-in-desktop-dir)
        (message "Session not saved."))
    (desktop-save-in-desktop-dir)))

;; DO NOT EDIT custom-set-variables!!
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(current-language-environment "English")
 '(ede-project-directories (quote ("/home/ajaym/.julia/dev/RavanaFS")))
 '(ediff-split-window-function (quote split-window-vertically))
 '(global-font-lock-mode t nil (font-lock))
 '(org-agenda-files (quote ("~/Workspace/chunking/docs/Design.org")))
 '(package-selected-packages
   (quote
    (riscv-mode helm-etags-plus lsp-ui lsp-mode use-package eide ecb ## weechat ac-html ac-c-headers ac-etags auto-complete magit yaml-mode web-mode vue-html-mode ssass-mode sr-speedbar rjsx-mode mmm-mode markdown-mode julia-shell flycheck-julia edit-indirect dumb-jump company-web company-shell company-math company-jedi company-go company-c-headers)))
 '(show-paren-mode t nil (paren))
 '(speedbar-show-unknown-files t)
 '(transient-mark-mode t))
 '(require 'xcscope)
 '(require 'multi-term)
 '(require 'magit)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ---------------------------------------------------------------------
;; Font and size functions
;; Set font
(when (member "DejaVu Sans Mono" (font-family-list))
  (set-face-attribute 'default nil :font "DejaVu Sans Mono-10"))
;; Key binding to increase font size
(global-set-key "\M-=" 'text-scale-increase)
;; Key binding to decrease font size
(global-set-key "\M--" 'text-scale-decrease)

;; ---------------------------------------------------------------------
;; Coding style and warnings
;; Enable parenthesis matching
(show-paren-mode t)
(setq show-paren-style 'mixed)

;; I hate tabs!
(setq-default indent-tabs-mode nil)

;; Enable 2 spaces for indentation
(setq-default c-basic-offset 2)

;; Show
;;   1. empty lines at beginning and end of buffer
;;   2. highlight lines greater than 80 chars
;;   3. trailing white spaces
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; ---------------------------------------------------------------------
;; cscope config
;; cscope gets its own frame
;(setq special-display-buffer-names
;      ("*cscope*" ))

;; Set cscope database directory
;; (setq cscope-initial-directory "~/sandbox/tx_aggregation_ic2/advfs/")

(put 'upcase-region 'disabled nil)
(load "~/emacs/xcscope")
(require 'xcscope)

;; Load package to diff directory trees
(add-to-list 'load-path "~/emacs")
(require 'ediff-trees)

;; ---------------------------------------------------------------------
;; Magit config
;; Make magit work with whitespace-mode
(defun prevent-whitespace-mode-for-magit ()
  (not (derived-mode-p 'magit-mode)))
(add-function :before-while whitespace-enable-predicate 'prevent-whitespace-mode-for-magit)

;; Load magit
(add-to-list 'load-path "~/emacs/magit")
(require 'magit)
(autoload 'magit-status "magit" nil t)

(add-to-list 'load-path "/usr/share/emacs/site-lisp/apel")


;; ---------------------------------------------------------------------
;; Some quick window shifting
;; Toggle window dedication
(defun toggle-window-dedicated ()
"Toggle whether the current active window is dedicated or not"
(interactive)
(message
 (if (let (window (get-buffer-window (current-buffer)))
       (set-window-dedicated-p window
                               (not (window-dedicated-p window))))
     "Window '%s' is dedicated"
   "Window '%s' is normal")
 (current-buffer)))

(global-set-key [pause] 'toggle-window-dedicated)

;; Switch between windows using shift-<left|right>
(when (fboundp 'windmove-default-keybindings)
      (windmove-default-keybindings))
(setq windmove-wrap-around t)

;; ---------------------------------------------------------------------
;; ediff config
;; To invoke emacs diff from the cmd line
;; Usage: emacs -diff file1 file2
(defun command-line-diff (switch)
      (let ((file1 (pop command-line-args-left))
            (file2 (pop command-line-args-left)))
        (ediff file1 file2)))

;;(add-to-list 'command-switch-alist '("-diff" . command-line-diff))

;; To split emacs diff vertically
(setq ediff-split-window-function 'split-window-horizontally)

;; Enlarge ediff control panel
(add-hook 'ediff-startup-hook
          (lambda ()
            (progn
              (select-frame-by-name "Ediff")
              (set-frame-size(selected-frame) 40 10))))

;; ---------------------------------------------------------------------

;; ido mode for better buffer management
(ido-mode t)

;; elscreen
;;(require 'elscreen)
;;(elscreen-start)

;; ---------------------------------------------------------------------
;; Set package repos
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; Org-mode's repository
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;; Initialize (load path) to packages installed with package manager
(package-initialize)

;; ---------------------------------------------------------------------
;; Rarely used qiuck access functions
;;quick access hacker news
(defun hn ()
(interactive)
(browse-url "http://news.ycombinator.com"))

;;quick access reddit
(defun reddit (reddit)
  "Opens the REDDIT in w3m-new-session"
  (interactive (list
                (read-string "Enter the reddit (default: psycology): " nil nil "psychology" nil)))
  (browse-url (format "http://m.reddit.com/r/%s" reddit))
)

;;wikipedia search
(defun wikipedia-search (search-term)
  "Search for SEARCH-TERM on wikipedia"
  (interactive
   (let ((term (if mark-active
                   (buffer-substring (region-beginning) (region-end))
                 (word-at-point))))
     (list
      (read-string
       (format "Wikipedia (%s):" term) nil nil term)))
   )
  (browse-url
   (concat
    "http://en.m.wikipedia.org/w/index.php?search="
    search-term
    ))
)

;; ---------------------------------------------------------------------
;; Orm mode config
(require 'org-install)
;;(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-edit-src-code)
(define-key global-map "\C-cx" 'org-edit-src-exit)

(setq org-log-done t)
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(setq org-todo-keywords
       '((sequence "TODO" "|" "DONE" "DISCARDED" "DELEGATED")))

;; Enable source code blocks in org mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t) ; this line activates dot
   (gnuplot . t) ; this line activates gnuplot
   )
 )

(setq reftex-default-bibliography '("~/Dropbox/bibliography/references.bib"))
(setq org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib"))
(setq helm-bibtex-bibliography '("~/Dropbox/bibliography/references.bib"))
;; open pdf with system pdf viewer (works on mac)
(setq helm-bibtex-pdf-open-function
  (lambda (fpath)
    (start-process "open" "*open*" "open" fpath)))

;; optional but very useful libraries in org-ref
;;(require 'doi-utils)
;;(require 'jmax-bibtex)
;;(require 'pubmed)
;;(require 'arxiv)
;;(require 'sci-id)

;; Quickly move to my org file
(defun open-my-org ()
  (interactive)
  "Open my default org file in a buffer"
  (find-file "/home/dropbox/Dropbox/personal/org/todo.org")
  )
(global-set-key (kbd "C-x C-o") 'open-my-org)

(setq org-latex-pdf-process
   '("xelatex -interaction nonstopmode -output-directory %o %f" "biber %b" "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f"))

;; ---------------------------------------------------------------------
;; Julia Editing
(add-to-list 'load-path "/home/ajaym/Workspace/julia-emacs")
(require 'julia-mode)

(add-to-list 'load-path "/home/ajaym/Workspace/julia-repl")
(require 'julia-repl)
(add-hook 'julia-mode-hook 'julia-repl-mode) ;; always use minor mode
;; (setq julia-repl-switches "-p 4")  ;; Julia env variables

;; (load "/home/ajaym/Workspace/ESS/lisp/ess-site")
;; (setq inferior-julia-program-name "/home/ajaym/Workspace/julia/julia")

;; (require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)

;; Use lsp-mode for the language server protocol
;; (add-to-list 'load-path "/home/ajaym/.emacs.d/elpa/lsp-mode-6.0")
;; (require 'lsp-mode)

;; Allow popups in lsp-mode
;; (require 'lsp-ui)

;; lsp-julia for julia bindings. Also need to install LanguageServer.jl
;; (add-to-list 'load-path "~/.emacs.d/lsp-julia")
;; (require 'lsp-julia)
;; (add-hook 'julia-mode-hook #'lsp-mode)

;; ---------------------------------------------------------------------
;; enable rjsx mode for js files
(add-to-list 'auto-mode-alist '(".*\\.js\\'" . rjsx-mode))
;; Set indentation for js
(setq js-indent-level 2)

;; ---------------------------------------------------------------------
;; Web mode for .html files
;;(defun my-web-mode-hook ()
;;  "Hooks for Web mode."
;;  (setq web-mode-markup-indent-offset 2)
;;  (setq web-mode-css-indent-offset 2)
;;  (setq web-mode-code-indent-offset 2)
;;
;;)
;;(add-hook 'web-mode-hook  'my-web-mode-hook)

;;(require 'web-mode)
;;(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;(dumb-jump-mode)

;; ---------------------------------------------------------------------
;; Programmable indentation - actuall I don't switch between modes at all
(defun my-setup-indent (n)
  ;; java/c/c++
  (setq-local c-basic-offset n)
  ;; web development
  (setq-local coffee-tab-width n) ; coffeescript
  (setq-local javascript-indent-level n) ; javascript-mode
  (setq-local js-indent-level n) ; js-mode
  (setq-local js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  (setq-local web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq-local web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq-local web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq-local css-indent-offset n) ; css-mode
  )

(defun my-office-code-style ()
  (interactive)
  (message "Office code style!")
  ;; use tab instead of space
  (setq-local indent-tabs-mode t)
  ;; indent 4 spaces width
  (my-setup-indent 4))

(defun my-personal-code-style ()
  (interactive)
  (message "My personal code style!")
  ;; use space instead of tab
  (setq indent-tabs-mode nil)
  ;; indent 2 spaces width
  (my-setup-indent 2))

(defun my-setup-develop-environment ()
  (interactive)
  (let ((proj-dir (file-name-directory (buffer-file-name))))
    ;; if hobby project path contains string "hobby-proj1"
    (if (string-match-p "kinant" proj-dir)
        (my-personal-code-style))

    ;; if commericial project path contains string "commerical-proj"
    (if (string-match-p "commerical-proj" proj-dir)
        (my-office-code-style))))

;; prog-mode-hook requires emacs24+
(add-hook 'prog-mode-hook 'my-setup-develop-environment)
;; a few major-modes does NOT inherited from prog-mode
(add-hook 'lua-mode-hook 'my-setup-develop-environment)
(add-hook 'web-mode-hook 'my-setup-develop-environment)

;; ---------------------------------------------------------------------
;; Helm completion settings
(require 'helm)
(global-set-key "\M-f" 'helm-find-files)
(global-set-key "\M-b" 'helm-buffers-list)

;; ---------------------------------------------------------------------
;; etags setup
;; enable help completion for etags
(require 'helm-etags-plus)
;; Global list of TAGS files
(add-to-list 'tags-table-list "~/Workspace/julia/base/TAGS")
(add-to-list 'tags-table-list "~/Workspace/julia/stdlib/TAGS")
;;search for symbol at point
(global-set-key "\M-." 'helm-etags-plus-select)
;;list all visited tags
(global-set-key "\M-*" 'helm-etags-plus-history)
;;go back directly
(global-set-key "\M-," 'helm-etags-plus-history-go-back)
;;go forward directly
(global-set-key "\M-/" 'helm-etags-plus-history-go-forward)

;(add-to-list 'load-path "~/.emacs.d/etags-table")
;(require 'etags-select)
;(require 'etags-table)
;(setq etags-table-alist tag-table-alist) ;; Adjustment for Xemacs
;(setq etags-table-search-up-depth 10) ;; Search parent dirs until a CTAGS file is found
;(setq tags-case-fold-search nil) ; case sensitive search
;(global-set-key "\M-?" 'etags-select-find-tag-at-point)
;(global-set-key "\M-." 'etags-select-find-tag)
;(setq etags-table-alist
;      '(
;        (".*\\.jl$" "~/bin/")
;        ))
;; ---------------------------------------------------------------------
