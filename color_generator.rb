
def deleteDirectory(dirPath)
    if File.directory?(dirPath)
      Dir.foreach(dirPath) do |subFile|
        if subFile != '.' and subFile != '..' 
          deleteDirectory(File.join(dirPath, subFile));
        end
      end
      Dir.rmdir(dirPath);
    else
      File.delete(dirPath) if File::exists?(dirPath);
    end
end


def assembleContent(name, hex)
    #.XMVisual.Color.Brown.B
    name_sep = name.gsub(Regexp.new(/[A-Z]+/),".\\&")
    name_arr = name_sep.split(".")
    style = name_arr[3,name_arr.length-4].join("")
    target_arr = name_arr[1..2]
    target_arr.push(style, name_arr.last)

    name_dot = target_arr.join(".")
    colorName = "#{name.chop}#{hex}"
    str = %Q|<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>IDECodeSnippetCompletionPrefix</key>
	<string>#{colorName}</string>
	<key>IDECodeSnippetCompletionScopes</key>
	<array>
		<string>All</string>
	</array>
	<key>IDECodeSnippetContents</key>
	<string>#{name_dot}</string>
	<key>IDECodeSnippetIdentifier</key>
	<string>#{colorName}</string>
	<key>IDECodeSnippetLanguage</key>
	<string>Xcode.SourceCodeLanguage.Swift</string>
	<key>IDECodeSnippetPlatformFamily</key>
	<string>iphoneos</string>
	<key>IDECodeSnippetSummary</key>
	<string></string>
	<key>IDECodeSnippetTitle</key>
	<string>#{colorName}</string>
	<key>IDECodeSnippetUserSnippet</key>
	<true/>
	<key>IDECodeSnippetVersion</key>
	<integer>2</integer>
</dict>
</plist>
|
    return str
end


filePath = Dir.pwd + "/XMBundleL0/Classes/Defines/XMVisual.swift"
colorFile = File.open(filePath, "r")
if colorFile
    filePath = Dir.pwd + "/Snippets"
    deleteDirectory filePath
    Dir.mkdir filePath
    content = colorFile.readlines
    name_pat = /(XMVisualColorBlack|DarkGray|Gray|LightGray|White|Red|Orange|Yellow|Green|Cyan|Blue|Purple|Brown[A-Z]{1})/
    hex_pat = /\/\/\/#[A-Za-z0-9]{6}/
    content.each_index do |i|
        name = content[i].strip
        hex = (i > 0 ? content[i-1] : "").strip
        if name =~ name_pat && hex =~ hex_pat
            name_res = Regexp.new(/@objc\(/)
            name = name.gsub(name_res, "")
            name = name.delete(")")
            puts name
            hex = hex.delete("///#")
            puts hex
            fileName = "#{name.chop}#{hex}.codesnippet"
            puts fileName
            tempfilename = File.join(filePath, fileName)
            puts tempfilename
            tempfile = File.new(tempfilename, "w")
            input_str = assembleContent(name, hex)
            tempfile.puts input_str
            tempfile.close
        end
    end
else
    puts "unable to open file"
end




  
