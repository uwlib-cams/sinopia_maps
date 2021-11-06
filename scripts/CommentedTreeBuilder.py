# Copied/pasted from:
# https://stackoverflow.com/questions/33573807/faithfully-preserve-comments-in-parsed-xml

from xml.etree import ElementTree

class CommentedTreeBuilder(ElementTree.TreeBuilder):
    def comment(self, data):
        self.start(ElementTree.Comment, {})
        self.data(data)
        self.end(ElementTree.Comment)
