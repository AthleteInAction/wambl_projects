system 'git add .'
system "git commit -m 'Ruby [#{(Time.now.to_f*100).round}]'"
system 'git push'