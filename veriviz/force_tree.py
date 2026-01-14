import pyslang
import msgspec
from pathlib import Path

DATA_OUTPATH = Path("examples/force_tree/")


class ModuleFinder:
    """Visitor that finds all module instances in a design. Inspired by slang-hier."""

    def __init__(self):
        # traversal variables
        self.stack = []
        self.root = None

    def __call__(self, node):
        if isinstance(node, pyslang.InstanceSymbol):
            if node.isModule:
                current = {
                    "name": f"{node.definition.name} ({node.name})",
                    "children": [],
                }
                if self.stack:
                    self.stack[-1]["children"].append(current)
                else:
                    self.root = current
                self.stack.append(current)

                node.body.visit(self)
                self.stack.pop()
                if not current["children"]:  # leaf node
                    del current["children"]
                    current["value"] = 1

                return pyslang.VisitAction.Skip

    def dump(self, outfile: str):
        outpath = DATA_OUTPATH / f"{outfile}.json"
        with open(outpath, "wb") as f:
            f.write(msgspec.json.encode(self.root))


source_manager = pyslang.SyntaxTree.getDefaultSourceManager()
loader = pyslang.SourceLoader(source_manager)

loader.addFiles("hdl/basic/*.sv")
loader.addFiles("hdl/intermediate/*.sv")
loader.addFiles("hdl/advanced/*.sv")

# loader.addSearchDirectories("include/")
# loader.addSearchExtension(".svh")

comp_options = pyslang.CompilationOptions()
# comp_options.topModules = {"example2_top"}

bag = pyslang.Bag([comp_options])

trees = loader.loadAndParseSources(bag)

comp = pyslang.Compilation(bag)
for tree in trees:
    comp.addSyntaxTree(tree)

root = comp.getRoot()
for instance in root.topInstances:
    visitor = ModuleFinder()
    instance.visit(visitor)

    visitor.dump(instance.definition.name)
