import pyslang
import msgspec


class ModuleFinder:
    """Visitor that finds all module instances in a design. Inspired by slang-hier."""

    def __init__(self):
        # traversal variables
        self.stack = []
        self.root = None

    def __call__(self, node):
        # Two other methods:
        # 1. Call Slang methods to find parent
        # 2. Only keep track of parent instead of stack
        if isinstance(node, pyslang.InstanceSymbol):
            if node.isModule:
                current = {"name": f"{node.definition.name} ({node.name})", 'children': []}
                if self.stack:
                    self.stack[-1]["children"].append(current)
                else:
                    self.root = current
                self.stack.append(current)

                node.body.visit(self)
                self.stack.pop()
                if not current["children"]: # leaf node
                    del current["children"]
                    current["value"] = 1

                return pyslang.VisitAction.Skip

    def dump(self):
        with open("data.json", "wb") as f:
            f.write(msgspec.json.encode(self.root))


source_manager = pyslang.SyntaxTree.getDefaultSourceManager()
loader = pyslang.SourceLoader(source_manager)

loader.addFiles("../examples/circle_packing/rtl/*.sv")

# loader.addSearchDirectories("include/")
# loader.addSearchExtension(".svh")

# comp_options = pyslang.CompilationOptions()
# comp_options.topModules.add("top")

# bag = pyslang.Bag([comp_options])
bag = pyslang.Bag()

trees = loader.loadAndParseSources(bag)

comp = pyslang.Compilation(bag)
for tree in trees:
    comp.addSyntaxTree(tree)

root = comp.getRoot()
top = root.topInstances[0]
visitor = ModuleFinder()
top.visit(visitor)

visitor.dump()

