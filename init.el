;;;-------------------------------------------------------------------
;;; portability (base of init.el location directry)
;;;-------------------------------------------------------------------
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path user-emacs-directory)

;;;-------------------------------------------------------------------
;;; el-get
;;;-------------------------------------------------------------------
(let ((versioned-dir (locate-user-emacs-file (format "v%s" emacs-version))))
  (setq-default el-get-dir (expand-file-name "el-get" versioned-dir)
    package-user-dir (expand-file-name "elpa" versioned-dir)))

;; bundle (El-Get wrapper)
(setq-default el-get-emacswiki-base-url
  "http://raw.github.com/emacsmirror/emacswiki.org/master/")
(add-to-list 'load-path (expand-file-name "bundle" el-get-dir))
(unless (require 'bundle nil 'noerror)
  (with-current-buffer
    (url-retrieve-synchronously
      "http://raw.github.com/tarao/bundle-el/master/bundle-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
(add-to-list 'el-get-recipe-path (locate-user-emacs-file "recipes"))

;;;-------------------------------------------------------------------
;;; Language (common)
;;;-------------------------------------------------------------------
(set-language-environment "Japanese")

;;;-------------------------------------------------------------------
;;; Language (for recent linux)
;;;-------------------------------------------------------------------
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

;;;-------------------------------------------------------------------
;;; Language (for old linux)
;;;-------------------------------------------------------------------
;; (prefer-coding-system 'utf-8)
;; (set-default-coding-systems 'euc-jp)
;; (set-keyboard-coding-system 'euc-jp)
;; (set-terminal-coding-system 'euc-jp)

;;;-------------------------------------------------------------------
;;; Language (for windows)
;;;-------------------------------------------------------------------
;; (prefer-coding-system 'cp932-dos)
;; (set-default-coding-systems 'cp932-dos)
;; (set-keyboard-coding-system 'euc-jp)
;; (set-terminal-coding-system 'euc-jp)

;;;-------------------------------------------------------------------
;;; Macro
;;;-------------------------------------------------------------------
;; define key global-map
(defmacro defkey (keymap key command)
  `(define-key ,keymap ,(read-kbd-macro key) , command))
(defmacro gdefkey (key command)
  `(define-key global-map ,(read-kbd-macro key) , command))

;; require
(defmacro req (lib &rest body)
  `(when (locate-library ,(symbol-name lib))
     (require ',lib) ,@body))

;;;-------------------------------------------------------------------
;;; Function (short)
;;;-------------------------------------------------------------------
(defun what-cursor-position-charcode ()
  ""
(interactive)
  (let* ((char (following-char))
        (str (format "0x%02x" char char)))
    (if (called-interactively-p 'interactive)
        (message "%s" str)
      str)))

(defun other-window-or-split ()
  ""
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(defun minibuffer-delete-duplicate ()
  (let (list)
    (dolist (elt (symbol-value minibuffer-history-variable))
      (unless (member elt list)
        (push elt list)))
    (set minibuffer-history-variable (nreverse list))))
(add-hook 'minibuffer-setup-hook 'minibuffer-delete-duplicate)

(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

(defun other-window-or-split ()
  ""
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

;;;-------------------------------------------------------------------
;;; Base Setting
;;;-------------------------------------------------------------------
(global-hl-line-mode t)
(setq hl-line-face 'underline)
(if window-system
    (menu-bar-mode 1) (menu-bar-mode -1))
(transient-mark-mode t)
(delete-selection-mode t)
(scroll-lock-mode t)
(savehist-mode t)
(temp-buffer-resize-mode t)
(load "saveplace")
;(setq highlight-nonselected-windows t)
(show-paren-mode t)
;(setq show-paren-style 'mixed)
(setq vc-follow-symlinks t)
(setq scroll-step 1)
;(setq scroll-preserve-screen-position t)
(setq blink-matching-paren t)
(blink-matching-open)
(setq-default show-trailing-whitespace t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message "")
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq message-log-max 10000)
(setq history-length 10000)
(setq visible-bell t)
(setq kill-whole-line t)
(setq kill-ring-max 30)
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))
(setq-default case-fold-search nil)
;(file-name-shadow-mode t)
(setq lazy-highlight-initial-delay 0)
(setq search-highlight nil)
(setq require-final-newline nil)
(setq next-line-add-newlines nil)
(setq grep-find-command "find . -exec grep \"\" {} /dev/null \\;") ; other grep options are set in bashrc
(setq grep-command "grep -r \"\" .") ; other grep options are set in bashrc
(setq compile-command "gcc -g -Wall -o test ")
;(setq compile-command "g++ -g -Wall -o test ")
(setq abbrev-file-name (concat user-emacs-directory ".abbrev_defs"))
(setq save-abbrevs t)
(quietly-read-abbrev-file)
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq-default ediff-auto-refine-limit 10000)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))
(setq gc-cons-threshold (* 5 gc-cons-threshold))
(defalias 'yes-or-no-p 'y-or-n-p)
;; (defvar gud-gdb-command-name "mips-uclibc-gdb")
;; (setq gud-gdb-command-name "mipsel-linux-uclibc-gdb --full --epoch /home/tani/export/test")
(setq gdb-many-windows t)  ; enabled if use gdb (non gud-gdb)
(setq gdb-use-separate-io-buffer t)
(setq gud-tooltip-echo-area nil)
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))

;;;-------------------------------------------------------------------
;;; mode-line
;;;-------------------------------------------------------------------
(line-number-mode t)
(column-number-mode t)
(which-function-mode t)
;(display-time)

(setq-default mode-line-format
              '("-"
                mode-line-mule-info
                mode-line-modified
                " "
                mode-line-buffer-identification
                " "
                (line-number-mode "L%l")
                "%[("
                (-3 . "%p")
                "%n" ")%] "
                (column-number-mode "C%c")
                " "
                (:eval (what-cursor-position-charcode))
                " "
                (which-func-mode ("" which-func-format))
                " %[("
                mode-name
                mode-line-process
                "%n" ")%] "
                "-%-")
              )

;;;-------------------------------------------------------------------
;;; Key Binding
;;;-------------------------------------------------------------------
;; global map
(gdefkey "<right>" 'forward-word)
(gdefkey "<left>" 'backward-word)
(gdefkey "C-h" 'delete-backward-char)
(gdefkey "C-j" 'newline)
(gdefkey "C-o" 'hippie-expand)
(gdefkey "C-q" 'scroll-down)
(gdefkey "C-t" 'other-window-or-split)
;; (gdefkey "C-t" '(lambda () (interactive) (ansi-term "/bin/bash")))
;; (gdefkey "C-t" '(lambda () (interactive) (ansi-term "/bin/tcsh")))
(gdefkey "C-v" 'scroll-up)
;; (gdefkey "C-c h" 'helm-mini)
(gdefkey "M-g" 'goto-line)
(gdefkey "M-h" 'help-for-help)
(gdefkey "M-t" 'follow-delete-other-windows-and-split)
(gdefkey "M-/" 'redo)  ; undo set "C-/"
;; (gdefkey "M-%" 'foreign-regexp/query-replace)
(global-set-key [f3] 'kmacro-start-macro-or-insert-counter)
(global-set-key [f4] 'kmacro-end-or-call-macro)
(global-set-key [f7] 'enlarge-window)
(global-set-key [f8] 'enlarge-window-horizontally)
(global-set-key [f9] 'point-to-register)
(global-set-key [f10] 'jump-to-register)
;; (global-set-key [f10] 'list-registers)
(global-set-key [f11] 'backward-up-list)
(global-set-key [f12] 'moccur-grep-find)

;; isearch-mode-map
(defkey isearch-mode-map "C-n" 'isearch-ring-advance)
(defkey isearch-mode-map "C-p" 'isearch-ring-retreat)

;; minibuffer-local-*-map
(defkey minibuffer-local-isearch-map "C-n" 'next-history-element)
(defkey minibuffer-local-isearch-map "C-p" 'previous-history-element)
(defkey minibuffer-local-must-match-map "C-p" 'previous-history-element)
(defkey minibuffer-local-must-match-map "C-n" 'next-history-element)
(defkey minibuffer-local-completion-map "C-p" 'previous-history-element)
(defkey minibuffer-local-completion-map "C-n" 'next-history-element)
(defkey minibuffer-local-map "C-p" 'previous-history-element)
(defkey minibuffer-local-map "C-n" 'next-history-element)

;;;-------------------------------------------------------------------
;;; Auto Mode Alist
;;;-------------------------------------------------------------------
(setq auto-mode-alist (cons '(".\\rc$" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.inc$" . makefile-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.mak$" . makefile-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Makefile\\..*$" . makefile-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.md$" . gfm-mode) auto-mode-alist))  ;; Github flavor markdown mode
(setq auto-mode-alist (cons '("\\.mdwn$" . gfm-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.markdown$" . gfm-mode) auto-mode-alist))

;;;-------------------------------------------------------------------
;;; Packages (not install)
;;;-------------------------------------------------------------------
;; common lisp sentence
(req cl)

;; saveplace
(req saveplace
  (setq-default save-place t)
  (setq save-place-file (concat user-emacs-directory ".emacs-places")))

;; ido-mode
(req ido
  (ido-mode t))

;; ibuf-ext
(req ibuf-ext
  (setq ibuffer-default-sorting-mode 'recency)
  (add-to-list 'ibuffer-never-show-predicates "^\\*")
  (define-ibuffer-column
    coding
    (:name " coding ")
    (if (coding-system-get buffer-file-coding-system 'mime-charset)
	(format " %s" (coding-system-get buffer-file-coding-system 'mime-charset))
      " undefined"
      ))
  (setq ibuffer-formats '((mark modified read-only " "
				(name 35 35) " "
				(size 6 -1) " "
				(coding 12 12) " "
				(mode 15 15))
			  (mark (name 25 -1) " "
				(coding 12 12) " "
				(mode 15 -1))
			  ))
  (gdefkey "\C-x\C-b" 'ibuffer))

;; wdired
(req wdired
     (setq wdired-allow-to-change-permissions t))

;; uniquify
(req uniquify
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

;; color-moccur
(req color-moccur)

;;;-------------------------------------------------------------------
;;; Packages (install with el-get-list-packages)
;;;-------------------------------------------------------------------
;; with-eval-after-load-feature (Eval after loading feature with fine compilation)
(bundle with-eval-after-load-feature)

;; tabbar (Display a tab bar in the header line)
(bundle tabbar)
(req tabbar
  (tabbar-mode t)
  (setq tabbar-buffer-groups-function nil)
  (setq tabbar-separator '(1.5))
  (dolist (btn '(tabbar-buffer-home-button
		 tabbar-scroll-left-button
		 tabbar-scroll-right-button))
    (set btn (cons (cons "" nil)
		   (cons "" nil))))
  (setq tabbar-auto-scroll-flag t)
  (defvar my-tabbar-displayed-buffers
    '("*Faces*" "*vc-")
    "*Regexps matches buffer names always included tabs.")
  (defun my-tabbar-buffer-list ()
    ""
    (let* ((hides (list ?\ ?\*))
	   (re (regexp-opt my-tabbar-displayed-buffers))
	   (cur-buf (current-buffer))
	   (tabs (delq nil
		       (mapcar (lambda (buf)
				 (let ((name (buffer-name buf)))
				   (when (or (string-match re name)
                                           (not (memq (aref name 0) hides)))
				     buf)))
			       (buffer-list)))))
      ;; Always include the current buffer.
      (if (memq cur-buf tabs)
	  tabs
	(cons cur-buf tabs))))
  (setq tabbar-buffer-list-function 'my-tabbar-buffer-list)
  (gdefkey "<right>" 'tabbar-forward-tab)
  (gdefkey "<left>" 'tabbar-backward-tab))

;; session (package Session restores various variables)
(bundle session)
(req session
  (setq session-initialize '(de-saveplace session keys menus places)
	session-globals-include '((kill-ring 50)
				  (session-file-alist 500 t)
				  (file-name-history 10000)))
  (setq session-globals-max-string 100000000)
  (setq history-length t)
  (add-hook 'after-init-hook 'session-initialize)
  (setq session-undo-check -1))

;; revive (saves current editing status including the window splitting configuration)
(bundle revive)
(req revive
  (setq revive:save-variables-local-private '(mark-active))
  (autoload 'save-current-configuration "revive" "Save status" t)
  (autoload 'resume "revive" "Resume Emacs" t)
  (autoload 'wipe "revive" "Wipe emacs" t)
  (setq revive:configuration-file (concat user-emacs-directory ".revive.el"))
  (gdefkey "M-r" 'resume) ; with save-current-configuration
  (gdefkey "M-s" 'save-current-configuration))

;; redo+ (Redo/undo system for Emacs)
(bundle redo+)
(req redo+
  (setq undo-no-redo t)
  (setq undo-limit 60000)
  (setq undo-strong-limit 600000))

;; bm (Visible, persistent, buffer local, bookmarks)
(bundle bm)
(req bm
  ;; save bookmarks
  (setq-default bm-buffer-persistence t)
  ;; Filename to store persistent bookmarks
  (setq bm-repository-file (concat user-emacs-directory ".bm-repository"))
  ;; Loading the repository from file when on start up.
  (add-hook' after-init-hook 'bm-repository-load)
  ;; Restoring bookmarks when on file find.
  (add-hook 'find-file-hooks 'bm-buffer-restore)
  ;; Saving bookmark data on killing and saving a buffer
  (add-hook 'kill-buffer-hook 'bm-buffer-save)
  (add-hook 'auto-save-hook 'bm-buffer-save)
  (add-hook 'after-save-hook 'bm-buffer-save)
  ;; Saving the repository to file when on exit.
  ;; kill-buffer-hook is not called when emacs is killed, so we
  ;; must save all bookmarks first.
  (add-hook 'kill-emacs-hook '(lambda nil
				(bm-buffer-save-all)
				(bm-repository-save)))
  (gdefkey "M-n" 'bm-next)
  (gdefkey "M-p" 'bm-previous)
  (gdefkey "M-SPC" 'bm-toggle))

;; browse-kill-ring (Interactively insert items from kill-ring)
(bundle browse-kill-ring)
(req browse-kill-ring
  (setq browse-kill-ring-quit-action 'kill-and-delete-window)
  ;; (setq browse-kill-ring-highlight-current-entry t)
  (setq browse-kill-ring-separator-face 'font-lock-comment-delimiter-face)
  (gdefkey "M-y" 'browse-kill-ring))

;; sequential-command (Many commands into one command)
(bundle sequential-command)
;; sequential-command-config (Examples of sequential-command)
(bundle sequential-command-config)
(req sequential-command-config
  (sequential-command-setup-keys))

;; popwin (Popup Window Manager)
(bundle popwin)
(req popwin
  (setq display-buffer-function 'popwin:display-buffer)
  (setq popwin:special-display-config '(
					(" *auto-async-byte-compile*" :height 0.3 :tail On)
					("*Kill Ring*" :height 0.5)
					("*Help*" :height 0.5)
					("*Completions*" :height 0.5)
					("*Ido Completions*" :height 0.5)
					("*Backtrace*" :height 0.5)
					(" *undo-tree*" :height 0.5)
					("Items-in-" :regexp t :height 0.3)
					)))

;; lcomp (list completion hacks)
(bundle lcomp)
(req lcomp
  (lcomp-install))

;; imenu-anywhere (Ido/helm imenu tag selection across all buffers with the same mode)
(bundle imenu-anywhere)
(req imenu-anywhere)

;; recentf-ext (Recentf extensions)
(bundle recentf-ext)
(req recentf-ext
  (setq recentf-exclude '("/TAGS$" "/var/tmp/" ".recentf" "COMMIT*" ".ido.last" ".revive.el" ".loaddefs.el"))
  (setq recentf-max-saved-items 2000)
  (global-set-key [f1] 'recentf-open-files))

;; grep-a-lot (manages multiple search results buffers for grep.el)
(bundle grep-a-lot)
(req grep-a-lot)

;; moccur-edit (apply replaces to multiple files)
(bundle moccur-edit)
(req moccur-edit
  (setq moccur-grep-default-word-near-point t)
  (setq dmoccur-recursive-search t)
  (setq moccur-split-word t)
  (setq dmoccur-exclusion-mask
    (append '("\\~$" "\\.o$" "\\.a$" "\\.svn\\/\*" "\\.git\\/\*" "\\.hg\\/\*" "GPATH" "GRTAGS" "GSYMS" "GTAGS") dmoccur-exclusion-mask)))

;; gtags (gtags facility for Emacs)
(bundle gtags)
(req gtags
  (global-set-key [f5] 'gtags-find-tag)       ; gtags-find-tag-other-window
  (global-set-key [f6] 'gtags-pop-stack))

;; emacs-w3m (simple Emacs interface to w3m)
(bundle emacs-w3m)
(req emacs-w3m
  (setq browse-url-generic-program
    (executable-find "/usr/bin/w3m")
    browse-url-browser-function 'browse-url-generic))

;; websocket (websocket implementation in elisp, for emacs)
(bundle websocket)
(req websocket)

;; markdown-mode (Major mode to edit Markdown files in Emacs)
(bundle markdown-mode)
(req markdown-mode
  (defun markdown-custom ()
    "markdown-mode-hook"
    (setq markdown-command-needs-filename t))
  (add-hook 'markdown-mode-hook '(lambda() (markdown-custom)))
  (defun w3m-browse-url-other-window (url &optional newwin)
    (let ((w3m-pop-up-windows t))
      (if (one-window-p) (split-window))
      (other-window 1)
      (w3m-browse-url url newwin)))
  (defun markdown-render-w3m (n)
    (interactive "p")
    (message (buffer-file-name))
    (call-process "/usr/bin/pandoc" nil nil nil
		  (buffer-file-name)
		  "-s" "-o"
		  "/tmp/mdconv.html")
    (w3m-browse-url-other-window "file://tmp/mdconv.html"))
  (define-key markdown-mode-map "\C-c\C-c" 'markdown-render-w3m))

;; magit (An Emacs mode for Git)
(bundle magit)
(req magit
  (setq magit-last-seen-setup-instructions "1.4.0"))

;; git-commit-mode (Major mode for editing git commit messages)
(bundle git-commit-mode)
(req git-commit-mode)

;;;-------------------------------------------------------------------
;;; Packages (install 3rdparty elisp)
;;;-------------------------------------------------------------------
;; el-get-lock (lock the pacakge versions)
(bundle tarao/el-get-lock
  (el-get-lock))

;; Color theme
(bundle bitswitcher/themes-el
  :name themes)
(add-to-list 'custom-theme-load-path (concat el-get-dir "/themes"))
(load-theme 'simple-dark t)

;; reopen-file
(bundle bitswitcher/reopen-file-el
  :name reopen-file
  (req reopen-file))

;; gtags-ext
(bundle bitswitcher/gtags-ext-el
  :name gtags-ext
  (req gtags-ext
    (setq gtags-select-buffer-single t)))

;; jaspace2 (Make Japanese whitespaces visible)
(bundle bitswitcher/jaspace-el
  :name jaspace2
  (req jaspace2
    (setq jaspace-modes (append jaspace-modes
				(list 'makefile-mode
				      'makefile-gmake-mode)))
    (setq jaspace-alternate-jaspace-string "□")
    ;(setq jaspace-highlight-tabs ?^) ; abnormal
    (setq jaspace-highlight-tabs t)))

;;;-------------------------------------------------------------------
;;; command memo
;;;-------------------------------------------------------------------
; magit-status
; re-builder
; imenu-anywhere
; eshell
; ielm (C-c C-d => ielm finish)
; locate-library
; install-elisp-from-emacswiki [*.el]
; list-faces-display / list-colors-display
; revert-buffer / reopen-file
; wipe
; describe-face-at-point
; vc-*  [e.g] print-log/diff/version-diff/annotate
; table-insert
; upcase-word / downcase-word
; define-global-abbrev
; gtags-visit-rootdir / gtags-find-rtag / gtags-find-symbol
; toggle-read-only (C-x C-q)
; write-file
; hexl-mode
; gud-gdb (face -> comint-highlight-input)
; moccur-grep / moccur-grep-find
; align / align-regexp / indent-region
; follow-mode (follow-delete-other-windows-and-split)
; column-highlight-mode
; ediff-merge / ediff-buffers / ediff-directories
; se/make-summary-buffer
; describe-char