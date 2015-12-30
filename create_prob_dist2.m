function create_prob_dist2(in_pic_scan)

% creates 200X200X93 array (93 is number of important symbols) with
% probability distributions for each symbol on each 200X200 page

[letters_dist_mat,count_each_letter]=user_finds_letters(bwisolate2_precise(in_pic_scan));

letters_prob_mat=zeros(200,200,93);
for i=1:93
    letters_prob(:,:,i)=letters_dist_mat(:,:,i)./count_each_letter(i);
end

save('file_with_probdists.mat','letters_prob','count_each_letter')

end