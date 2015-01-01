from lxml import etree

# Efficient parsing of large XML files from
# http://stackoverflow.com/a/9814580/987185
def parse(fp):
    context = etree.iterparse(fp, events=('end',))

    for action, elem in context:
        if elem.tag=='row':
            # processing goes here
            assert elem.text is None, "The row wasn't empty"
            yield elem.attrib

        # cleanup
        # first empty children from current element
            # This is not absolutely necessary if you are also deleting
            # siblings, but it will allow you to free memory earlier.
        elem.clear()
        # second, delete previous siblings (records)
        while elem.getprevious() is not None:
            del elem.getparent()[0]
        # make sure you have no references to Element objects outside the loop


