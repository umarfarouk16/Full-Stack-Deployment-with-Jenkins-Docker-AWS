module.exports = {
    corsOrigins: [
      'http://localhost:3000',
      'http://techpathway-backend-alb-454838952.us-east-1.elb.amazonaws.com', // From terraform output
      '*'
    ],
    port: process.env.PORT || 8080
  };