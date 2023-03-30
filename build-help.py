from lxml import etree, html
from distutils.dir_util import copy_tree
import glob
import shutil
import os

def remove_empty_strings(string):
  return string != ""

def remove_new_lines(string):
  return string.strip()

def convtag(element, depth):
  if element.tag == "sect2":
    element.tag = "div"
  elif element.tag == "para":
    if "Written" in element.text:
      element.attrib['class'] = "author"
    element.tag = "p"
  elif element.tag == "title":
    element.tag = "h" + str(depth + 2)
  elif element.tag == "informaltable":
    element.tag = "table"
  elif element.tag == "row":
    element.tag = "tr"
  elif element.tag == "entry":
    element.tag = "td"
  elif element.tag == "phrase":
    element.tag = "p"
    element.attrib['class'] = "caption"
  elif element.tag == "imagedata":
    element.tag = "img"
    element.attrib['src'] = element.attrib.pop('fileref')
    element.attrib.pop('format')
  elif element.tag == "itemizedlist" or element.tag == "variablelist":
    element.tag = "ul"
  elif element.tag == "varlistentry":
    element.tag = "li"
  elif element.tag == "listitem":
    element.tag = "li"
  elif element.tag == "term":
    print("term converted to b - may not be appropriate")
    element.tag = "b"


def scrub(element, depth):
  for childElt in element:
    childElt.tail = None
    if childElt.text is not None:
      if len(childElt.text) > 100 and depth < 3:
        target = ('\n' + ('  ' * (depth + 4))).join(map(remove_new_lines, filter(remove_empty_strings, childElt.text.replace(".  ", ". ").split('  ')))).strip()
        childElt.text = '\n' + ('  ' * (depth + 4)) + target + '\n' + ('  ' * (depth + 3))
      else:
        childElt.text = (' '.join(childElt.text.split())).strip()
    convtag(childElt, depth)
    if element.tag == "li" and childElt.tag == "p":
      childElt.tag = "nil"
    elif element.tag == "li" and childElt.tag == "li":
      childElt.tag = "nil"
    scrub(childElt, depth + 1)

print("Writing index.css...")
with open('Solitaire/Solitaire.help/Contents/Resources/English.lproj/index.css', 'w') as cssFile:
  cssFile.write("body {\n")
  cssFile.write("  font-size: 15px;\n")
  cssFile.write("  font-weight: 400;\n")
  cssFile.write("  font-family: SF Pro Text,SF Pro Icons,Helvetica Neue,Helvetica,Arial,sans-serif;\n")
  cssFile.write("  line-height: 1.25rem\n")
  cssFile.write("}\n\n")
  cssFile.write("h1, h2, h3, h4, h5, h6 {\n")
  cssFile.write("  font-weight: 500;\n")
  cssFile.write("}\n\n")
  cssFile.write("h1 {\n")
  cssFile.write("  font-size: 26px;\n")
  cssFile.write("}\n\n")
  cssFile.write("h2 {\n")
  cssFile.write("  font-size: 18px;\n")
  cssFile.write("  padding: 0.8rem 0 0 0;\n")
  cssFile.write("}\n\n")
  cssFile.write("h3 {\n")
  cssFile.write("  font-size: 17px;\n")
  cssFile.write("  padding: 0.8rem 0 0 0;\n")
  cssFile.write("}\n\n")
  cssFile.write("h4 {\n")
  cssFile.write("  font-size: 16px;\n")
  cssFile.write("  padding: 0.8rem 0 0 0;\n")
  cssFile.write("}\n\n")
  cssFile.write("td {\n")
  cssFile.write("  padding: 0.6rem 0;\n")
  cssFile.write("  vertical-align: top;\n")
  cssFile.write("}\n\n")
  cssFile.write("td:first-child {\n")
  cssFile.write("  width: 150px;\n")
  cssFile.write("  font-weight: 500;\n")
  cssFile.write("}\n\n")
  cssFile.write(".main {\n")
  cssFile.write("  text-align: center;\n")
  cssFile.write("}\n\n")
  cssFile.write(".quote {\n")
  cssFile.write("  font-style: italic;\n")
  cssFile.write("  text-align: center;\n")
  cssFile.write("}\n\n")
  cssFile.write("p.caption {\n")
  cssFile.write("  margin: 0;\n")
  cssFile.write("  font-style: italic;\n")
  cssFile.write("  font-size: 14px;\n")
  cssFile.write("  color: #555;\n")
  cssFile.write("}\n\n")
  cssFile.write("p.author {\n")
  cssFile.write("  font-style: italic;\n")
  cssFile.write("  font-size: 14px;\n")
  cssFile.write("  color: #555;\n")
  cssFile.write("}\n")

allTitles = []

sortedGlob = sorted(glob.glob('Solitaire/help/C/aisleriot/*.xml'))

for path in sortedGlob:
  if 'definition' in path:
    pass
  else:
    print("Writing " + os.path.basename(path).replace('xml', 'html') + "...")
    with open(path) as sourceFile:
      source = etree.parse(sourceFile)
      root = source.getroot()
      page = etree.Element('html', lang='en')
      doc = etree.ElementTree(page)
      headElt = etree.SubElement(page, 'head')
      bodyElt = etree.SubElement(page, 'body')
      bodyElt.tail = None
      titleElt = etree.SubElement(headElt, 'title')
      title = next(root.iter('title')).text
      titleElt.text = title
      allTitles.append(title)
      cssElt = etree.SubElement(headElt, 'link', rel='stylesheet', href='index.css', type='text/css')
      cssElt.text = ""
      etree.strip_tags(root, 'tgroup')
      etree.strip_tags(root, 'screenshot')
      etree.strip_tags(root, 'mediaobject')
      etree.strip_tags(root, 'imageobject')
      etree.strip_tags(root, 'textobject')
      anchor = etree.SubElement(bodyElt, 'a')
      anchor.attrib['name'] = os.path.basename(path).replace('.xml', '')
      anchor.text = ""
      for childElt in root:
        if not isinstance(childElt, etree._Comment):
          childElt.tail = None
          convtag(childElt, -1)
          scrub(childElt, 0)
          etree.strip_tags(childElt, 'nil')
          bodyElt.append(childElt)
      # heading = bodyElt.find('h1')
      # anchor = etree.Element('a')
      # anchor.attrib['name'] = os.path.basename(path).replace('.xml', '')
      # anchor.insert(0, heading)
      # bodyElt.insert(0, anchor)
      # linkElt = etree.SubElement(headElt, 'link', rel='stylesheet', href='mystyle.css', type='text/css')
      with open('Solitaire/Solitaire.help/Contents/Resources/English.lproj/' + os.path.basename(path).replace('xml', 'html'), 'wb') as destFile:
        destFile.write("<!DOCTYPE html>\n".encode("utf8"))
        doc.write(destFile, pretty_print=True)

print("Writing index.html...")
root = source.getroot()
page = etree.Element('html', lang='en')
doc = etree.ElementTree(page)
headElt = etree.SubElement(page, 'head')
bodyElt = etree.SubElement(page, 'body')
bodyElt.tail = None
titleElt = etree.SubElement(headElt, 'title')
titleElt.text = "Marc Solitaire"
#metaElt = etree.SubElement(headElt, 'meta')
#metaElt.attrib['name'] = 'ROBOTS'
#metaElt.attrib['content'] = 'NOINDEX'
cssElt = etree.SubElement(headElt, 'link', rel='stylesheet', href='index.css', type='text/css')
iconElt = etree.SubElement(etree.SubElement(bodyElt, 'div', style='text-align: center; width: 100%'), 'img', src='figures/icon.png', style='margin: auto', width='256')
headingElt = etree.SubElement(bodyElt, 'h1')
headingElt.text = "Marc Solitaire"
headingElt.attrib['class'] = 'main'
quoteElt = html.fromstring("<p class=\"quote\">&ldquo;Soltaire is a lonely man&lsquo;s game, Hapsburg&rdquo; - Frank Drebin, Police Squad</p>")
bodyElt.insert(3, quoteElt)
introElt = etree.SubElement(bodyElt, 'p')
introElt.attrib['class'] = 'main'
introElt.text = "Marc Solitaire is a port of AisleRiot to macOS by Mark Pazolli with over 90 solitaire games available for play."
listElt = etree.SubElement(bodyElt, 'ul')
i = 0
for path in sortedGlob:
  if "definition" in path:
    pass
  else:
    linkElt = etree.SubElement(etree.SubElement(listElt, 'li'), 'a', href=os.path.basename(path).replace("xml", "html"))
    linkElt.text = allTitles[i]
    i += 1
with open('Solitaire/Solitaire.help/Contents/Resources/English.lproj/index.html', 'wb') as indexFile:
  indexFile.write("<!DOCTYPE html>\n".encode("utf8"))
  output = etree.tostring(doc, pretty_print=True)
  # Apple doesn't do &#8220; &#8216; and &#8221;
  output = output.replace(b'&#8220;', b'&ldquo;')
  output = output.replace(b'&#8221;', b'&rdquo;')
  output = output.replace(b'&#8216;', b'&rsquo;')
  indexFile.write(output)

print("Indexing...")
os.system("hiutil -Pv")
os.system("cd Solitaire/Solitaire.help/Contents/Resources/English.lproj && hiutil -I corespotlight -Caf help.cshelpindex -vv .")
os.system("cd Solitaire/Solitaire.help/Contents/Resources/English.lproj && hiutil -I corespotlight -Af help.cshelpindex")
os.system("cd Solitaire/Solitaire.help/Contents/Resources/English.lproj && hiutil -I lsm -Caf help.helpindex -vv .")
os.system("cd Solitaire/Solitaire.help/Contents/Resources/English.lproj && hiutil -I lsm -Af help.helpindex")

print("Copying figures...")
copy_tree("Solitaire/help/C/aisleriot/figures", "Solitaire/Solitaire.help/Contents/Resources/English.lproj/figures")
shutil.copyfile("icon-ii.iconset/icon_512x512.png", "Solitaire/Solitaire.help/Contents/Resources/English.lproj/figures/icon.png")
