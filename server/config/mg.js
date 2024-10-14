const formData = require('form-data');
const Mailgun = require('mailgun.js');
require('dotenv').config();

const mailgun = new Mailgun(formData);
const apiKey = process.env.MAILGUN_API_KEY

const mg = mailgun.client({
  username: 'api', 
  key: apiKey
});

function generateTFA() {
    const otp = Math.floor(100000 + Math.random() * 900000); 
    return otp;
  }

const sendOTP = async(email) =>{
  const otpCode = generateTFA();
  
  const htmlTemplate = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Your Verification Code</title>
      <style>
        body {
          background-color: #f3f4f6;
          font-family: 'Arial', sans-serif;
          margin: 0;
          padding: 20px;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }
        .container {
          background-color: white;
          border-radius: 8px;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
          padding: 30px;
          text-align: center;
          width: 300px;
        }
        .code {
          font-size: 32px;
          font-weight: bold;
          color: #EF3030;
          margin: 20px 0;
          letter-spacing: 4px;
        }
        .message {
          font-size: 16px;
          color: #555;
        }
        .footer {
          margin-top: 30px;
          font-size: 12px;
          color: #999;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h2>Your Verification Code</h2>
        <p class="message">Use the following code to complete your login:</p>
        <div class="code">${otpCode}</div>
        <p class="footer">This code will expire in 10 minutes. Please do not share it with anyone.</p>
      </div>
    </body>
    </html>
  `;
  
  try {
    const result = await mg.messages.create('sandbox6257d47e99a04c06b7327d7f760e9593.mailgun.org', {
      from: 'Kanaan Verification. <mailgun@sandbox6257d47e99a04c06b7327d7f760e9593.mailgun.org>',
      to: [email],
      subject: 'Your Verification Code',
      html: htmlTemplate
    });
    console.log('Email sent:', result);
    return otpCode;
  }catch (error){
    console.error('Error sending email:', error);
    return 0;
  }
}


module.exports = {sendOTP}