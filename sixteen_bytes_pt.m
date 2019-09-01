%load('aes_power_data.mat')
%we imported the downloaded data rather than using the load function

key=uint8(0:255); %row vector of all possible key values
number_of_traces=200;
difference_of_means=NaN(256,40000);
recovered_key=NaN(1,16);

for x=1:16  %finding the recovered key for each byte one at a time
    
plaintext_column=uint8(plain_text(:,x)); %16th byte of all of the plaintext messages in column vector 

pt_key_xor=bitxor(plaintext_column, key); % output of bitwise xor with plaintext and key 
% outputs a 200x256 matrix
% each row is the bitwise xor for the pt byte with every key guess
% 200 rows for the 200 pt messages

% adding 1 to all matrix elements to create the correct indices 
% [1:256] instead of [0:255]


new_pt_key_xor=pt_key_xor+1;

for a=1:256   % doing the same procedure for each password one at a time

s_box_output=sbox(new_pt_key_xor(:,a)); % the s-box output for all pt messages one key guess at a time

% take the LSB of all s box outputs

s_box_output_lsb=bitget(s_box_output,1);

% Selecting the number of traces to consider
traces=traces(1:number_of_traces,:);

bin_one_outputs=find(s_box_output_lsb); % finding the number of ones in the array

bin_zero_outputs=find(s_box_output_lsb==0); % finding the number of zeros in the array

bin_zero=traces(bin_zero_outputs,:);    % finding the bin_zero traces and including the 40000 instances
bin_one=traces(bin_one_outputs,:);  % finding the bin_one traces and including the 40000 instances

bin_zero_mean=mean(bin_zero);   % calculating the mean of both bin zero and bin one
bin_one_mean=mean(bin_one);

difference_of_means(a,:)=abs(bin_zero_mean-bin_one_mean);   % calculating the absolute value of the difference 

end

%flip the DoM to sort rows correctly
flipped_difference_of_means=difference_of_means';
%find the max value of the difference of means
max_difference_of_means=max(flipped_difference_of_means);
%add a column numbering from 0-255 to identify the corresponding key
new_max_difference_of_means=vertcat(max_difference_of_means,0:1:255);
%sort the rows from smallest to largest max DoM
sorted_max_difference_of_means=sortrows(new_max_difference_of_means');
%the recovered key is the last row and second column
recovered_key(x)=sorted_max_difference_of_means(end,2);

% plot 256 max differences for the first and last byte
if x == 1
    subplot(2,1,1);
    plot(max_difference_of_means(:,:))
    title("Max DoM for First Byte of Plaintext");
elseif x==16 
    subplot(2,1,2);
    plot(max_difference_of_means(:,:))
    title("Max DoM for Sixteenth Byte of Plaintext");
end
    
end

%calculate the accuracy between the binary of the recovered & actual key
actual_key = hexToBinaryVector(['00';'11';'22';'33';'44';'55';'66';'77';'88';'99';'AA';'BB';'CC';'DD';'EE';'FF']);
recovered_key_binary = decimalToBinaryVector(recovered_key');    % convert recovered key to binary
correct_bits = sum(sum(actual_key == recovered_key_binary));     % find total number of correct bits
accuracy = correct_bits/128*100;     % calculate the accuracy of the key

% print the pertinent data
fprintf('Recovered key: '), fprintf('%02x', recovered_key);
fprintf('\nAccuracy: %f\n', accuracy);



