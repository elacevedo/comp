import sys

from parser_file import Parser


def main(argv):
    with open('simple.decaf', 'r') as file:
        code = file.read()
    ast = Parser(code)
    ast.getTree()


if __name__ == "__main__":
    main(sys.argv)
