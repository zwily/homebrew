require 'formula'

class Dmd2 <Formula
  @homepage='http://www.digitalmars.com/d/'
  @url='http://ftp.digitalmars.com/dmd.2.047.zip'
  @md5='fb4da8a3e2cae24241d215a7097f6200'

  def doc
    #use d and not dmd, rationale: meh
    prefix+'share/doc/d2'
  end

  def caveats; <<-EOS
You should not install this alongside dmd (D version 1).
    EOS
  end

  def install
    ohai "Installing dmd2"

    # clean it up a little first
    Dir['src/*.mak'].each {|f| File.unlink f}
    FileUtils.mv 'license.txt', 'COPYING'
    FileUtils.mv 'README.TXT', 'README'
    FileUtils.mv 'src/phobos/phoboslicense.txt', 'src/phobos/COPYING.phobos'

    prefix.install 'osx/lib'
    prefix.install 'osx/bin'
    prefix.install 'src'
    man.install 'man/man1'

    (prefix+'src/dmd').rmtree # we don't need the dmd sources thanks
    (man+'man5').install man1+'dmd.conf.5' # oops
    (prefix+'share/d/examples').install Dir['samples/d/*.d']

    (prefix+'bin/dmd.conf').open('w') do |f|
      f.puts "[Environment]"
      f.puts "DFLAGS=-I#{prefix}/src/phobos -I#{prefix}/src/druntime/import -L-L#{prefix}/lib"
    end
  end
end