# Facebook_social_networkR
R code, data, and environment to create a social network plot of mutual friends on Facebook as seen in the blog post <a href="https://seaturtlessg.wordpress.com/2019/04/19/mutual-friends-network-analysis-in-r/" target="_blank" rel="noopener">Mutual Friends Network Analysis in R</a>. People's identity and the social circles they're in have been coded to protect identities.</br></br>
There are four files that can be used here:
<ul>
  <li><strong>'association_GIT_final.csv'</strong> is a dataframe containing (1) the friend number, (2) the social group which I have organized them to (based on how I know them), and (3) the friend code, which is their name.</li>
  <li><strong>'network_GIT_final.csv'</strong> is the network matrix. You need to delete the first column and make the rownames the same as the column names for this to work.</li>
  <li><strong>'FB_Social_Circles_GIT.R'</strong> is the script to create the network analysis plot in R.</li>
  <li><strong>'FB_Social_circles_GIT.RDATA'</strong> is the R environment containing all the objects.</li>
</ul>
