system("
cd YOUR_H2O_DIRECTORY/h2o-3.1.0.3098-cdh5.4.2 # Your H2O version should be different
hadoop jar h2odriver.jar -output h2o -timeout 6000 > YOUR_WORKING_DIR/h2o_msg.txt",wait=F) 
#timeout: timeout duration. See here for more H2O parameters

h2o_ip <- NA; h2o_port <- NA
while(is.na(h2o_ip)&is.na(h2o_port)){
f <- tryCatch(read.table('h2o_msg.txt',header=F,sep='\n'),error = function(c) data.table(NA))
firstNode <- as.character(f[grep('H2O node',f$V1),][1])
firstNodeSplit <- strsplit(firstNode,' ')[[1]][3]
h2o_ip <- strsplit(firstNodeSplit,':')[[1]][1]
h2o_port <- as.numeric(strsplit(firstNodeSplit,':')[[1]][2])
}
h2o = h2o.init(ip=h2o_ip,port=h2o_port,startH2O=F)

YOUR_AWESOME_H2O_JOBS

applicationNo <- strsplit(as.character(f[grep('application_',f$V1),]),' ')[[1]][10]
system(paste0('yarn application -kill ',applicationNo))
system('hadoop fs -rm -r h2o')
system('rm YOUR_WORKING_DIR/h2o_msg.txt')