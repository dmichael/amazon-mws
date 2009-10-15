Ruby library for Amazon Marketplace Web Service (MWS)
=====================================================

Amazon::MWS is a set of classes for using the Amazon Marketplace Web Service, a link to Amazon's Seller Central.
This library is in active development, but should now work for the most part.

These classes are modeled after aspects of AWS::S3, check it out: http://amazon.rubyforge.org/

Description
===========

The Amazon SellerCentral API is a rather convoluted beast. The incarnation that this library services is the Frankenstein's monster known as the Amazon Marketplace Web Service or MWS. 

It is fairly obvious that the team at Amazon's SellerCenter would like their MWS API to be like those in the Amazon Web Services such as S3, EC2 and kin. Unfortunately, there are a number of design choices made in the MWS API that make it kinda RESTful, and kinda SOAPy, but ultimately neither and really just some strange cross-bred mutation of an API style (sleepy soap?).

For instance, all requests for action on Amazon's part are POSTed to single URI with an enormous XML payload (whose structure is only defined by XSDs). When POSTing data to Amazon, you must submit query params that 1) explicitly tells MWS that you are posting data (FeedType=\_POST\_PRODUCT\_DATA\_) and 2) tell what is in the XML payload (MessageType=Product). It is not clear why this level of redundancy is necessary, nor why this information could not be obtained from the context of the request. But hey, its better than SOAP.

I understand that Amazon is looking to transition off it's incredibly complex SOAP API, and while MWS is an improvement, its still confusing and a little painful. Hopefully this library can hide the lurid details of the MWS API.