
function mat_randomized_2=expand_logicmat(in)

% This function converts every symbol into a constant 200X200 pixel version
% Easier to use for calculating probablity distributions

[r,c]=size(in);
%square_length=input('Side length of new square matrix');
square_length=200;
expanded_mat=zeros(square_length);
ratio_r= floor(square_length/r);
ratio_c= floor(square_length/c);
rem_r= rem(square_length,r);
rem_c= rem(square_length,c);

%Stretch out to matrix r by square_length. Leave remainder as zeros
for i=1:r
    x=zeros(1,square_length);
    place_holder=1;
    for j=1:c
        end_holder=place_holder+ratio_c-1;
        if in(i,j)==0;
            place_holder=place_holder+ratio_c;
        elseif in(i,j)==1;
            x(place_holder:end_holder)=1;
            place_holder=place_holder+ratio_c;
        end
    end
    expanded_mat(i,:)=x;
end

%Stretch out to matrix square_length by square_length. Leave remainder as zeros
for i=1:square_length
    x=zeros(square_length,1);
    place_holder=1;
    for j=1:r
        end_holder=place_holder+ratio_r-1;
        if expanded_mat(j,i)==0
            place_holder=place_holder+ratio_r;
        elseif expanded_mat(j,i)==1
            x(place_holder:end_holder)=1;
            place_holder=place_holder+ratio_r;
        end
    end
    expanded_mat(:,i)=x;
end

%Randomly distribute remainder zeros into logic matrix. This method
%should make the remainder zeros not matter in the long run because with
%many scanned letters, the probabilities will hardly show up bc these zeros
%will never be in the same spot enough times to make a difference.
mat_randomized_1=zeros(square_length);
for i=1:square_length-rem_r;
    rand_indexes= randperm(square_length,rem_c);
    rand_indexes=sort([0,rand_indexes]);
 
    place_holder=1;
    place_holder_2=1;
    for z=1:rem_c;
    mat_randomized_1(i,place_holder_2:(rand_indexes(z+1)-1))=expanded_mat(i,place_holder:(place_holder+(rand_indexes(z+1)-rand_indexes(z)-2)));
    
    place_holder=rand_indexes(z+1)-z+1;
    place_holder_2=rand_indexes(z+1)+1;
    
    end

    mat_randomized_1(i,place_holder_2:end)=expanded_mat(i,place_holder:(square_length-rem_c));
end

mat_randomized_2=zeros(square_length);
for i=1:square_length;
    rand_indexes= randperm(square_length,rem_r);
    rand_indexes=sort([0,rand_indexes]);
 
    place_holder=1;
    place_holder_2=1;
    for z=1:rem_r;
    mat_randomized_2(place_holder_2:(rand_indexes(z+1)-1),i)=mat_randomized_1(place_holder:(place_holder+(rand_indexes(z+1)-rand_indexes(z)-2)),i);
    
    place_holder=rand_indexes(z+1)-z+1;
    place_holder_2=rand_indexes(z+1)+1;
    
    end

    mat_randomized_2(place_holder_2:end,i)=mat_randomized_1(place_holder:(square_length-rem_r),i);

end


mat_randomized_2=(mat_randomized_2==1);


