const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 587,
  secure: false, // true for 465, false for other ports
  auth: {
    user: '#',
    pass: '#', // Replace with your email and app password
  },
});

email = "1zbenjaminortiz@gmail.com"
otp = "81991"

async function sendOTP(email, otp) {
  try {
    await transporter.sendMail({
      from: '"Your App Name" <your-email@gmail.com>',
      to: email,
      subject: 'Your Verification Code',
      text: `Your OTP is ${otp}. It will expire in 10 minutes.`,
    });
    console.log('OTP sent successfully');
  } catch (error) {
    console.error('Error sending OTP:', error);
  }
}

sendOTP(email, otp)