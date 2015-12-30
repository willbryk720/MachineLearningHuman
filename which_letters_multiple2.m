function which_letters_multiple2(pic_of_letters_to_output)

% takes image input and oututs the symbols in the image

in_mat=bwisolate2_precise(pic_of_letters_to_output);

num_lett_line=300 ;
num_line=20;
map=[0 0 0; 1 1 1];
colormap(map)

%scan this
e=load('file_with_probdists.mat');
letters_prob_mat=e.letters_prob;


%scanned_letters=zeros(1,num_lett_line*num_line);

output_text=char(num_lett_line,num_line);
[r,c]=size(in_mat);
current_line_row=1;
current_line_col=1;

av_width=0;

for j=1:num_line %looping through all lines of text
loc=0;
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
    

    %Divide line of letters into box (size of line) with only one letter in it
    for z=1:num_lett_line  % looping through number of letters in line
        line_text_copy=zeros(r_box,c_box);
         for i=current_line_col:c
            sum_col=sum(line_text(:,i));
            if sum_col>0
                col_value=i;
                if (j==1 & z>=2) || (j>=2)
                    if (col_value-current_line_col)>av_width
                        loc=loc+1;
                        scanned_letters(loc)=' ';
                    end
                end
                break
            end
         end
         if (i==c && sum_col<1)  % In case there are no more letters in line
              break
         end

         %r_1,c_1 rows and columns of points with 1 at every stage
         [r_1,c_1]=find(line_text(:,col_value)==1);
         c_1=c_1+col_value-1;
         line_text_copy(r_1,col_value)=1;         
         %Now with the first few (or maybe 1), lets begin to find 1's of whole
         %letter
         for num_iterations=1:300
            num_new_points=0;
            numel_r_1=numel(r_1);  %just to make sure a changing r_1 size doesn't affect loop
            for i=1:numel_r_1 
                %m stands for move- ex. move up/left
                move=zeros(8,2);
                move(1,:)=[r_1(i)-1,c_1(i)];  %up          
                move(2,:)=[r_1(i)+1,c_1(i)];  %down
                move(3,:)=[r_1(i),c_1(i)-1];  %left
                move(4,:)=[r_1(i),c_1(i)+1];  %right
                move(5,:)=[r_1(i)-1,c_1(i)-1];  %up-left
                move(6,:)=[r_1(i)-1,c_1(i)+1];  %up-right
                move(7,:)=[r_1(i)+1,c_1(i)-1];  %down-left
                move(8,:)=[r_1(i)+1,c_1(i)+1];  %down-right
                for g=1:8
                    if ((move(g,1)>=1) && (move(g,1)<=r_box) && (move(g,2)>=1) && (move(g,2)<=c)) %make sure the coordinates of this point that surrounds the former exists
                        if ((line_text(move(g,1),move(g,2))==1) && (line_text_copy(move(g,1),move(g,2))==0))
                            num_new_points=num_new_points+1;
                            r_2(num_new_points)=move(g,1);
                            c_2(num_new_points)=move(g,2);
                            line_text_copy(move(g,1),move(g,2))=1;             
                        end
                    end
                end   
                
            end
            
            %In case there are no new points, and so the loop you end.
            %We've found that elusive letter!
            if (num_new_points>=1)
                r_1=r_2(1:num_new_points);
                c_1=c_2(1:num_new_points);        
            end
            if (num_new_points==0)
                break
            end
                
         end 

         
         %Now we have big linebox with letter inside. Lets isolate letter.
         %First by column
         for i=1:c
            sum_col=sum(line_text_copy(:,i));
            if sum_col>1
                col_value=i;
                break
            end  
         end
         for i=c_box:-1:1
            sum_col=sum(line_text_copy(:,i));
            if sum_col>0
                col_value_2=i;
                break
            end
         end
         %...Then by row
         for i=1:r_box
            sum_row=sum(line_text_copy(i,:));
            if sum_row>0
                row_box_value=i;
                break
            end
         end
         for i=r_box:-1:1
            sum_row=sum(line_text_copy(i,:));
            if sum_row>0
                row_box_value_2=i;
                break
            end
         end
         
        current_line_col= col_value_2+1;
        %Lets make sure the letter/symbol is not some random point or something. Its gotta be 9 or bigger
        %because thats already a period.
        if sum(sum(line_text_copy))<9
            continue
        end         
        %Otherwise..
        next_letter= line_text_copy(row_box_value:row_box_value_2,col_value:col_value_2); %found letter
        loc=loc+1;
        av_width=(col_value_2-col_value+1+av_width*(loc-1))/loc;
       
        
        b=expand_logicmat(next_letter);
        b=double(b);
        b(b==0)= (1-2);
        value=zeros(1,93);

        for i=1:93
            value(i)=sum(sum(letters_prob_mat(:,:,i).*b));
        end
        %value
        [num,ind]=max(value);
        scanned_letters(loc)=char(ind+32);     
        
    end


    current_line_col=1; %reset current_line_col to 1 bc we begin at one on next line of text

    current_line_row=row_value_2+1; %current_line_row has progressed to next line
    
    %scanned_letters
    output_text=char(output_text,scanned_letters);
    scanned_letters(1:end)=[];
    
    if (row_value_2==r && j<num_line)
        break
    end
end  % end looping through all lines of text

disp(output_text);

end
