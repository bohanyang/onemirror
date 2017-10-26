How to configure SSL?
    
    1. Add your SSL certificate and private key to here
    
    2. Run the command
    
        openssl dhparam -out dhparam.pem 4096
        
       to generate a strong DH parameter for security
    
    3. Make sure you have a DH parameter file dhparam.pem in this folder and
       open the nginx.conf. Look for a commented line start with a sharp
       character (#) and ssl_dhparam. Uncomment it to let the parameter take
       affect

    4. You can consider to enable Certificate Tranparency. Generate your SCT
       files with github.com/grahamedgecombe/ct-submit
       
    5. Go to the conf.d/google.conf to know how to configure in your site's
       configuration and see the example
