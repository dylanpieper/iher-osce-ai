-- Expand srcdoc-file="path" on a raw HTML element into an inline srcdoc attribute.
-- Keeps the embedded document same-origin with the slides, so its JS (localStorage,
-- tabsets) works. A data: URI would give it an opaque origin instead.

local function escape_attr(s)
  return (s:gsub("&", "&amp;"):gsub('"', "&quot;"))
end

local function read_file(path)
  local f = io.open(path, "rb")
  if not f then
    error("srcdoc-file not found: " .. path)
  end
  local content = f:read("*a")
  f:close()
  return content
end

local function expand(el)
  if not el.format:match("^html") then
    return nil
  end
  local path = el.text:match('srcdoc%-file="([^"]+)"')
  if not path then
    return nil
  end
  local attr = 'srcdoc="' .. escape_attr(read_file(path)) .. '"'
  el.text = el.text:gsub('srcdoc%-file="[^"]+"', function() return attr end)
  return el
end

return {
  { RawBlock = expand, RawInline = expand }
}
