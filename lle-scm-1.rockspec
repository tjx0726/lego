package = "lle"
version = "scm-1"

source = {
   url = "git://bitbucket.org:iassael/torch-lego.git",
   tag = "master"
}

description = {
   summary = "Lego Learning Environment (LLE) for Torch",
   detailed = [[
      Lego Learning Environment (LLE) for Torch
   ]],
   homepage = "https://bitbucket.com/iassael/torch-lego",
   license = "BSD"
}

dependencies = {
   "lua >= 5.1",
   "torch >= 7.0",
   "nn",
   "nngraph",
   "xml",
   "image",
   "class",
   -- totem required for tests only, so let's not put it here
}

build = {
   type = "command",
   build_command = [[
cmake -E make_directory build;
cd build;
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)"; 
$(MAKE)
   ]],
   install_command = "cd build && $(MAKE) install"
}
