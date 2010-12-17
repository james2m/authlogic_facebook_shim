afk_path = File.join(File.dirname(__FILE__), *%w(.. .. .. ..))
afk_lib_path = File.join(afk_path, "lib")

$LOAD_PATH.unshift(afk_lib_path)
load File.join(afk_path, "init.rb")
