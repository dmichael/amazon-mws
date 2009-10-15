Ruby library for Amazon Marketplace Web Service (MWS)
=====================================================

TODO
===========

* Complete the Reports API
* The API calls in general are under development
* Parse the responses intelligently (not just as a hash)
* Better documentation

Intro
===========

Amazon::MWS is a set of classes for using the Amazon Marketplace Web Service, a link to Amazon's Seller Central.
This library is in active development, but should now work for the most part. If you would like to contribute to this project, please contact me.

These classes are modeled after aspects of AWS::S3, check it out: http://amazon.rubyforge.org/

Description
===========

The Amazon SellerCentral API is a rather weighty beast. The incarnation that this library services is the Amazon Marketplace Web Service or MWS. 

It is fairly obvious that the team at Amazon's SellerCenter would like their MWS API to be like those in the Amazon Web Services such as S3, EC2 and kin. Unfortunately, there are a number of design choices made in the MWS API that make it kinda RESTful, and kinda SOAPy, but when the lights go on, we have here Frankenstein's monster API.

To illustrate, indulge me in an example. All requests for action on Amazon's part are POSTed to single URI with an XML payload (whose structure can only be inferred from XSDs). When POSTing data to Amazon, you must submit query params that 1) explicitly tell MWS that you are posting data (FeedType=\_POST\_PRODUCT\_DATA\_) and 2) tell MWS what is in the XML payload (MessageType=Product). It is not clear why this level of redundancy is necessary, nor why this information could not be obtained from the context of the request.

I understand that Amazon is looking to transition off it's incredibly complex SOAP API, and while MWS is an improvement, its still confusing and a little painful. I very much look forward to Amazon's continued refinement of their MWS API.

Enjoy!

Usage
===========

Stay tuned, we are working on it!