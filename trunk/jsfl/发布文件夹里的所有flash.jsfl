var folderURI = fl.browseForFolderURL("ѡ���ļ���");
if (FLfile.exists(folderURI)) {
   var fileMask = "*.fla";
   var list = FLfile.listFolder(folderURI + "/" + fileMask, "files");
    for(var i in list)
    {
    var doc = fl.openDocument(folderURI + "/"+list[i]);
    doc.exportSWF(folderURI + "/" + list[i].substr(0,list[i].length - 4) + ".swf",true);
    fl.saveDocument(doc , folderURI + "/"+list[i]);
    doc.close();
    fl.trace(list[i]+"�������");
    }
}