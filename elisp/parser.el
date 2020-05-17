(require 'ox)
(require 'seq)

;; ================================================================================
;; Org utility functions
;; ================================================================================

(defun get-current-level (element)
  "Get the level to which ELEMENT belongs"
  (let ((headline (org-element-lineage element '(headline) t)))
    (if headline
        (org-element-property :level headline)
      0)))

(defun get-affiliated (element)
  (buffer-substring (org-element-property :begin element)
                    (org-element-property :post-affiliated element)))

(defun get-post-blank (element)
  (org-element-property :post-blank element))


(defun delete-comments (doc)
  "Remove comments, comment blocks, and commented trees from Org document tree DOC"
  (org-element-map doc '(comment comment-block) 'org-element-extract-element)
  (org-element-map doc 'headline
    (lambda (hl)
      (and (org-element-property :commentedp hl)
           (org-element-extract-element hl)))))

;; Property drawers
;; --------------------------------------------------------------------------------
(defun make-node-property (key value)
  "Make a node property"
  (org-element-create
       'node-property
       (list :key key :value value)))

(defun make-property-drawer (&rest nodes)
  "Make a property drawer"
  (apply 'org-element-create
         'property-drawer nil nodes))

;; Headlines
;; --------------------------------------------------------------------------------
(defun make-headline (title level &rest children)
  "Build a headline with the given TITLE and LEVEL"
  (apply 'org-element-create
         'headline (list :title title :level level)
         children))

(defun make-headline-unnumbered (title level)
  "Build an umnnumbered headline with the given TITLE and LEVEL"
  (make-headline
   title level
   (make-property-drawer
    (make-node-property "UNNUMBERED" t))))


;; Links
;; --------------------------------------------------------------------------------
(defun make-link (type path)
  "Makes a link"
  (org-element-create 'link (list :type type :path path)))


(defun make-par-link (type path affiliated post-blank)
  "Returns an Org paragraph with a link"
  (org-element-create
   'paragraph
   (list :post-blank post-blank)
   affiliated
   (make-link type path)))


;; ================================================================================
;; XXX keywords
;; ================================================================================

(defun process-xxx-keywords (doc)
  "Get the different parts of a XXX keyword and call the appropriate handler"
  (org-element-map doc 'keyword
    (lambda (keyword)
      (let ((type)
            (text)
            (value))
        (when (string= (org-element-property :key keyword) "XXX")
          (setq text (org-element-property :value keyword))
          (when (string-match
                 "[[:blank:]]*\\([^[:blank:]]+\\)\\(?:[[:blank:]]+\\(.*\\)\\)?[[:blank:]]*\\'" text)
            (setq type (match-string 1 text)
                  value (match-string 2 text))
            (cond ((string= type "col") (xxx-col keyword value))
                  ((string= type "fig") (xxx-fig keyword value))
                  (t nil))))))))


(defun fig-file-path (value lang)
  (if (string-match "\\*" value)
      (replace-match (or lang "\\LANG") nil t value)
    value))

(defun xxx-fig (element value)
  (org-element-set-element
   element
   (make-par-link
    "file"
    (fig-file-path value nil)
    (get-affiliated element)
    (get-post-blank element))))


;; ================================================================================
;; Problems
;; ================================================================================

(defun handle-section (section)
  "Collect answers within a section.

Extract answers (level 3 headlines) and add them to the contents of a new section
with the same title as the original one.
"
  (let ((answers)
        (new-section))
    (setq answers
          (org-element-map section 'headline
            (lambda (hl)
              (when (= (org-element-property :level hl) 3)
                (org-element-extract-element hl)))))
    (when answers
      (setq new-section (make-headline (org-element-property :title section) 2))
      (apply 'org-element-adopt-elements new-section answers))))


(defun make-solutions-section (doc)
  "Make a solutions section.

Iterate over first level sections and process then with handle-section.
Collect the results and add them to a new solutions section at the end
of the document."
  (let ((sections)
        (new-section))
    (setq sections
          (org-element-map doc 'headline
            (lambda (hl)
              (and (= (org-element-property :level hl) 1)
                   (handle-section hl)))))
    (when sections
      (setq new-section (make-headline-unnumbered "{{{Solutions}}}" 1))
      (apply 'org-element-adopt-elements new-section sections))))

(defun prepare-buffer ()
  "Parse problems document"
  (let ((doc))
    (org-export-expand-include-keyword)
    (setq doc (org-element-parse-buffer))
    (delete-comments doc)
    (org-element-adopt-elements doc (make-solutions-section doc))
    (process-xxx-keywords doc)
    (org-element-interpret-data doc)))

(defun preprocess-probl ()
  "Replace buffer with preprocessed probl document"
  (let ((new (prepare-buffer)))
    (erase-buffer)
    (insert new)))


(remove-hook 'org-export-before-parsing-hook 'preprocess-probl)
(add-hook 'org-export-before-parsing-hook 'preprocess-probl)
