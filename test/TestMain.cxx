#include <gtest/gtest.h>

class SomethingTest : public ::testing::Test
{
protected:
	//variables here

	SomethingTest()
	{
		//setup code here

	}

	~SomethingTest()
	{
		//cleanup code here
	}
};

TEST_F(SomethingTest, test_something_test_something)
{
	//do testing here
}
