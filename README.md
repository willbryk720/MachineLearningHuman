# MachineLearningHuman
You teach a computer your handwriting. Then you can take an image of your handwriting, upload it, and have the computer convert it to text.

Here's how to work it: First, download the files into a folder on Matlab. Then upload an image of your handwriting to the folder. This will be to teach the program how you write your letters/symbols. Try to include all the letters/symbols that you normally use, and write each a few times to give the program an accurate probability distribution for each letter. Make sure: 
- 1. To write on a blank sheet of paper
- 2. To space out the letters so they don't touch (no script!)
- 3. To space out your lines of text and to take a picture directly above the paper so that the lines are directly above one another (not slanted)
- 4. Write naturally and comfortably so what you write is an accurate depiction of your actual handwriting. I have included a screenshot called "teaching_text.png" for a first example.

Using "teaching_text.png" as an example:
From the Matlab command line type: create_prob_dist2('teaching_text.png')
- The program will ask you to enter the cutoffs for which part of the image you want to analyze. The units are pixels, so look at the image and find the top Row, bottom Row, left Column, right Column by the pixel number. This is done because if you took a picture of a paper on top of a desk and some of the desk got in it, you can crop the desk out so that the resulting image is just letters on a paper.
- The program will then ask you to input a number between 1 and 254 inclusive to adjust the contrast (this tells the program what are letters and what is background). Keep entering different numbers until the letters are pretty much contrasted to the background. Enter 0 when you're done. (The program will use an algorithm to try to make the contrast even better than what you saw).
- The program will then ask you to identify each letter in the image one by one. If the letter doesn't look like anything you could identify, type "~" (this often happens for apostrophes, periods, commas, etc.). This process might take long depending on how many letters/symbols are in the image.

Now, upload another image of letters, this time for the program to figure out. 
Using "teaching_text.png" as an example:
From the Matlab command line type: which_letters_multiple2('test_learning.png')
- Enter pixel cutoffs
- Adjust contrast

Wait for the magic to happen! (Well, almost)

The program does have difficulties with letters/symbols that have separate non-touching parts (like "i" and "j" and "!") because of the way the program reads the letters. The program also cannot handle different letters that are touching each other. This problem is explained more in the comments in the files. There are solutions that I may attempt in the future. 

Also, this project was meant to be a proof of concept for myself. When I wrote it I did not have other readers in mind, so it may be lacking in comments, and may lack approachable organization. If I were to do it again from scratch it would be more efficient. 
