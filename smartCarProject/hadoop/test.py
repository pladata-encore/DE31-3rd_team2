import unittest
from unittest.mock import patch, MagicMock
from hadoop_client import HadoopClient

class TestHadoopClient(unittest.TestCase):

    @patch('hadoop_client.InsecureClient')
    def setUp(self, MockClient):
        self.mock_client = MockClient.return_value
        self.hadoop_client = HadoopClient('http://192.168.0.160:50070', 'hdfs')

    def test_write_data(self):
        hdfs_path = '/user/hdfs/test.txt'
        data = 'Hello, Hadoop!'

        self.hadoop_client.write_data(hdfs_path, data)
        self.mock_client.write.assert_called_once_with(hdfs_path, encoding='utf-8')
        self.mock_client.write.return_value.__enter__().write.assert_called_once_with(data)

    def test_read_data(self):
        hdfs_path = '/user/hdfs/test.txt'
        expected_data = 'Hello, Hadoop!'

        self.mock_client.read.return_value.__enter__.return_value.read.return_value = expected_data

        data = self.hadoop_client.read_data(hdfs_path)
        self.mock_client.read.assert_called_once_with(hdfs_path, encoding='utf-8')
        self.assertEqual(data, expected_data)

    def test_list_files(self):
        hdfs_path = '/user/hdfs'
        expected_files = ['file1.txt', 'file2.txt']

        self.mock_client.list.return_value = expected_files

        files = self.hadoop_client.list_files(hdfs_path)
        self.mock_client.list.assert_called_once_with(hdfs_path)
        self.assertEqual(files, expected_files)


    def test_delete_files(self):
        pass


if __name__ == '__main__':
    unittest.main()

