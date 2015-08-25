#!/bin/bash
rm stocksnap.links
rm stocksnap.meta
rm -rf output
mkdir output

echo "collecting links to image metadata"
for i in `seq 1 240`;
do
   echo "page $i/240"
   curl -s -XGET https://stocksnap.io/view-photos/sort/date/desc/page-$i | grep "class=\"photo-link\"" | cut -d "\"" -f 4 >> stocksnap.links
done

echo "collecting images metadata"
cnt=`wc -l stocksnap.links`
i=1
for link in `cat stocksnap.links`;
do
   echo "image $i/$cnt"
   url="https://stocksnap.io$link"
   curl -s -XGET $url > stocksnap.page.tmp
   cat stocksnap.page.tmp | grep "img-responsive img-photo" | cut -d "\"" -f 4 >> stocksnap.meta
   cat stocksnap.page.tmp | grep "img-responsive img-photo" | cut -d "\"" -f 6 >> stocksnap.meta
   i=$(($i+1))
done
rm stocksnap.page.tmp

echo "downloading images"
i=1
cnt=`cat stocksnap.meta | grep https://snap-photos | wc -l`
for url in `cat stocksnap.meta | grep https://snap-photos`
do 
   echo "image $i/$cnt"
   curl -s -O -XGET $url
   mv *.jpg output/
   i=$(($i+1))
done

echo "done. check out \"output\" dir for images and stocksnap.meta for tags"
