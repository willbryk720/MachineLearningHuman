function logic_a_mat=bwisolate2_precise(in)

% takes image and isolates letters from background with black/white image


% we will use these values to best distinguish symbols from background
blur=20;
diff_factor=20;
num_line=8;

map=[0 0 0; 1 1 1];
colormap(map)

a=imread(in);
image(a)
    answer_2_str=input('Enter pixel cutoffs: First top Row, then bottom Row, then left Column, \nthen right Column, or if you do not want cutoffs enter "all" ','s');
    
    if length(answer_2_str)~=3
        answer_2_num=str2num(answer_2_str);
        a=a(answer_2_num(1):answer_2_num(2),answer_2_num(3):answer_2_num(4),:);
    end
    
sum_a_mat= a(:,:,1)/3 + a(:,:,2)/3 + a(:,:,3)/3;
sum_a_mat(sum_a_mat==0)=1;
logic_a_mat=false(size(sum_a_mat));

disp(sprintf('Now adjust initial brightness/contrast cutoff to let computer get ballpark estimate how bright the letters\n are with respect to backgroud (an algorithm will then make it better!). Try numbers anywhere from 1 to 254 (more likely something in\n the middle) and make sure you could see the letters stand out alone in white in a sea of black.'));
for i=1:10
    if i==1
        figure
    end
    
    initial_cutoff=input('Enter cutoff. Enter 0 once it looks good  ');
    if initial_cutoff==0
        break
    end
    in_mat=sum_a_mat<initial_cutoff;
    colormap(map)
    image(in_mat)
end
    


current_line_row=1;
[r,c]=size(in_mat);

for j=1:num_line %looping through all lines of text
    %Find Line of letters
    for i=current_line_row:r
        sum_row=sum(in_mat(i,:));
        if sum_row>0
            row_value=i;
            break
        end
    end
    if (i==r && sum_row<1)  % In case there are no more lines left
        break
    end
    for i=row_value:r
        sum_row=sum(in_mat(i,:));
        if sum_row<1
           row_value_2=i-1;
           break
        elseif (i==r && sum_row>0) % In case line lasts until end row
           row_value_2=i;    
        end
    end

    line_text=in_mat(row_value:row_value_2,:); %Found line of letters
    [r_box,c_box]=size(line_text);
    
    % uses brightness above and below letters to figure out the cutoff for
    % what is black and what is white
    for z=1:floor(c_box/blur)
        if row_value==1
            av_bott=sum(sum_a_mat(row_value_2+1,((z-1)*blur+1):((z-1)*blur+blur)))/blur;
            cutoff=(av_bott)-diff_factor;
        elseif row_value_2==r
            av_top=sum(sum_a_mat(row_value-1,((z-1)*blur+1):((z-1)*blur+blur)))/blur;
            cutoff=(av_top/2)-diff_factor;
        else
            av_top=sum(sum_a_mat(row_value-1,((z-1)*blur+1):((z-1)*blur+blur)))/blur;
            av_bott=sum(sum_a_mat(row_value_2+1,((z-1)*blur+1):((z-1)*blur+blur)))/blur;
            cutoff=((av_top+av_bott)/2)-diff_factor;
        end
        logic_a_mat(row_value:row_value_2,((z-1)*blur+1):((z-1)*blur+blur))=sum_a_mat(row_value:row_value_2,((z-1)*blur+1):((z-1)*blur+blur))<cutoff ;        
    end
    current_line_row=row_value_2+1; %current_line_row has progressed to next line

    %In case letters went until last row of image. Gotta remember to stop loop
    if (row_value_2==r && j<num_line)
        break
    end
end


map=[0 0 0; 1 1 1];
figure
colormap(map)
image(logic_a_mat)

end