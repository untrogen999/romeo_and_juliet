Avi Zilberman's stepfile, for reproducing everything I've done with marking up the index.
Anything in backticks (`) is a command of some sort or just some text to copy-paste. When using it make sure not to copy the backticks themselves.

Steps:

1. Make a copy of the source file and make it an XML file.
2. Delete line 11907 and everything after it. This removes the Project Gutenberg end text.
2. Delete lines 11631 to 11889 (both inclusive). This removes the advertisements and info about the book company. Also, the transcriber's notes should still be further indented than the index.
3. Delete everything before line 10380. The first line should now have the text "INDEX OF WORDS AND PHRASES EXPLAINED" and there now should be only one blank line after the bottom border of the "Transcriber's notes".
4. Find `&`, `<` and `>`, in that order: I saw none after doing the previous steps, so no need to do any replacements.
5. Find `\d+` to replace with `<page>\0</page>`. This marks up all the page numbers in the index.
6. Find `<page>.+</page>$` to replace with `<pages>\0</pages>`.
	* This encases all page numbers in a `<pages>` element for each entry.
	* This specifically uses greedy matching, so make sure "Dot Matches All" is OFF.
7. Find `\(= (.+?)\)` to replace with `<additive type="equiv">\1</additive>`
	* This replaces all additives (stuff in parentheses) that start with an equals sign with the proper element.
8. Find `\((.+?)\)` to replace with `<additive type="desc">\1</additive>`
	* This now replaces the content in parentheses that does NOT start with an equals sign.
9. Find `^ {2}([\w'!\,\-\?\.]+?),? ?(<.+?)$`.
	* Replace with `  <entry type="word"><term>\1</term>\2</entry>`. Note the two starting spaces.
	* This step's find regex searches for terms of a single word.
	* Some terms end with a comma and space, and others with just a space, and the rest with neither character. The (comma and) space after the term is/are removed if found.
10. Find `^ {2}([ \w'!\,\-\?\.]+?),? ?(<.+?)$`.
	* Replace with `  <entry type="phrase"><term>\1</term>\2</entry>`. Note the two starting spaces.
	* This step's find regex searches for phrases (terms with spaces in them). It's almost the exact same find regex, except that there's a space character right before the "\w".
	* The replace regex is also really similar to the replace regex of the previous step, but they're different only in the value of "type".
	* Some terms end with a comma and space, and the rest with just a space. The (comma and) space after the term is/are removed.
11. Manual steps:
	1. Create an "index" element at the top of the file. Put its closing tag at the very last line of the file.
	2. Make the text on the first line the value of an attribute called "title" of the new "index" element.
	3. Associate the schema with the index XML.
	4. Add a new blank line at the top of the file and paste the text "<?xml version="1.0" encoding="UTF-8"?>" into the blank line.
	5. Remove the "Transcriber's notes" entirely.



Notes to self:

* Entries are sorted alphabetically.
* The case of the first letter doesn't matter. So for example "Capel" in the index acts like "capel" in that it comes after "cankered" in the index.
* The index has both words and phrases mixed together. A phrase obviously has multiple words in it, but is there a phrase of only one word? Either way, entries with multiple words should be filtered out.
* There are 613 entries in total, at least according to the regex `^ {2}([ \w'!\,\-\?\.]+?),? ?(<.+?)$` when run right after step 8.
* There are 228 entries that have content in parentheses, at least according to the regex `\((.+?)\)` when run right after step 6.
* There are 377 entries where the terms end with a comma, at least according to the regex `^ {2}[ \w'!\,\-\?\.]+, <.+?$`. Mentioning this because no matches have content in parentheses, from what I saw.
