
  "<" @left
  ">" @right
  "</" @left
  "/>" @right


   [(tag_name)
    (#html-extended-rainbow-mode?)] @paren

[
  (element)
  (style_element)
  (script_element)]
@rainbow.level
