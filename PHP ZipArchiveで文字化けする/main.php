<?php

$filepath = dirname(__FILE__) ."ふがふが.txt.zip";

$zip = new ZipArchive();

if ($zip->open($filepath, ZIPARCHIVE::CREATE)){
    for ($i = 0; $i < $zip->numFiles; $i++) {
        echo "ファイル名: " . $zip->getNameIndex($i) . "\n";
    }
}

$zip->close();